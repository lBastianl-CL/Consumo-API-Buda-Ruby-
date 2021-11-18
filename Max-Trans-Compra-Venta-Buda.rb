require 'rest-client'
require 'json'

responsemarkets = RestClient.get('https://www.buda.com/api/v2/markets')
resultsmarkets = JSON.parse(responsemarkets.to_str)
first_timestamp = Time.now.to_i - 60*60*24

resultsmarkets['markets'].each do |market|
    responsetrades = RestClient.get('https://www.buda.com/api/v2/markets/'+market['name']+'/trades?='+first_timestamp.to_s)
    resultstrades = JSON.parse(responsetrades.to_str)
    temp = resultstrades['trades']['entries'] 
    last_timestamp = resultstrades['trades']['last_timestamp']
    contador = 0
    buy = []
    sell = []

    while contador <  temp.length
        if temp[contador][3] == "buy"
            buy[contador] = temp[contador][1].to_f*temp[contador][2].to_f
            sell[contador] = 0
            contador += 1
        else
            sell[contador] = temp[contador][1].to_f*temp[contador][2].to_f
            buy[contador] = 0
            contador += 1
        end
    end 

    puts "Max Buy  " + market['name']
    puts buy.max

    puts "Max Sell " + market['name']
    puts sell.max

end