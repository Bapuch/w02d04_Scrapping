require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'pry'

department_url = 'http://annuaire-des-mairies.com/val-d-oise.html'
xpath = 'html/body/table/tr[3]/td/table//tr/td//a'

def get_the_email_of_a_townhal_from_its_webpage(url)
  xpath_mail = '/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]'
  page = Nokogiri::HTML(open(url))
  page.xpath(xpath_mail).text
end

def get_all_the_urls_of_val_doise_townhalls(url, xpath)
  urls = {}
  page = Nokogiri::HTML(open(url))
  page.xpath(xpath).each do |el|
    next unless !el['href'].nil? && el['href'].length > 1

    urls[el.text] = "http://annuaire-des-mairies.com#{el['href'].delete_prefix('.')}"
  end

  urls
end

def get_all_the_mails_of_val_doise_townhalls(url, xpath)
  urls = {}
  page = Nokogiri::HTML(open(url))
  page.xpath(xpath).each do |el|
    next unless el['href'].length > 1 && !el['href'].include?('adobe.com') # !el['href'].nil? &&

    town_url = "http://annuaire-des-mairies.com#{el['href'].delete_prefix('.')}"
    urls[el.text] = get_the_email_of_a_townhal_from_its_webpage(town_url)
  end

  urls
end

puts "Press 1 to display the url of vaureal only\nPress 2 to display the url of all the towns in Val D'Oise\nPress 3 to display the eMails of all the towns in Val D'oise\nPress any other key to quit the program"
print ">> "
key = gets.chomp.to_i

case key
when 1
  puts get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com/95/vaureal.html")
when 2
  get_all_the_urls_of_val_doise_townhalls(department_url, xpath).each { |k, v| puts "#{k} ===> #{v}" }
when 3
  get_all_the_mails_of_val_doise_townhalls(department_url, xpath).each { |k, v| puts "#{k} ===> #{v}" }
end
