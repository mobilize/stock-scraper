require 'mechanize'
require 'csv'
require 'json'
tickers_path = "gsheet/mobilize_server_gmail_com/Mobilize Sample Jobs/tickers"
tickers = CSV.read(tickers_path).flatten

#output the metric header
puts "date\tticker\t@metric\n"

tickers.each do |ticker|

  yql_prefix = "http://query.yahooapis.com/v1/public/yql?q="
  yql_query = "select * from yahoo.finance.historicaldata where symbol ='#{ticker}' " +
              "and startDate='@start_date' and endDate='@end_date'"
  yql_suffix = "&env=store://datatables.org/alltableswithkeys"

  yql_query_enc = URI.encode(yql_query)

  agent = Mechanize.new
  file = agent.get("#{yql_prefix}#{yql_query}#{yql_suffix}")

  hash_array = JSON.parse(file.body)

  hash_array.each do |hash|
    #output each data point
    puts "#{hash['date']}\t#{ticker}\t#{hash['@metric']}\n"
  end
end
