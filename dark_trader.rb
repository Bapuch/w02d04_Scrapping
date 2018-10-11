require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'pry'

def crypto_price
  list_crypto_prices = []
  page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
  xpath_price = "//a[@class='price' and @data-usd]"
  xpath_name = "//a[@class='currency-name-container link-secondary']"
  (1..page.xpath(xpath_price).length).each do |i|
    next if page.xpath(xpath_price)[i].nil?

    list_crypto_prices.push({ page.xpath(xpath_name)[i].text => page.xpath(xpath_price)[i].text })
  end

  list_crypto_prices
end

def get_price_everyhour
  loop do
    puts ">>> starting crypto currency price retrieving now on #{Time.now}:"
    puts crypto_price
    puts ">>> Done at : #{Time.now} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "..sleeping for an hour now.."
    sleep(3600)
  end
end

puts "Press 1 to get crypto currencies prices once\nPress 2 to run the program every hour\nPress any other key to exit"
print ">> "
key = gets.chomp.to_i
case key
when 1
  crypto_price
when 2
  get_price_everyhour
end
