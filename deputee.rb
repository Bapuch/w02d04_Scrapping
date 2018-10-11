require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'pry'

assemblee_url = 'http://www2.assemblee-nationale.fr/deputes/liste/alphabetique'
xpath = "//*[@id='deputes-list']/div/ul/li/a" # "html/body/table/tr[3]/td/table//tr/td//a"

def get_the_email_of_a_deputee(url)
  xpath_mail = "//*[@id='haut-contenu-page']/article/div[3]/div/dl/dd/ul/li/a[starts-with(@href, 'mailto')]"
  mail = Nokogiri::HTML(open(url)).xpath(xpath_mail)
  mail.empty? ? 'no mail provided. Sorry..' : mail[0]['href'].delete_prefix('mailto:')
end

# puts get_the_email_of_a_deputee("http://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA759192")

def get_all_the_mails_of_deputees(url, xpath)
  list_deputee_mail = []
  page_xpath = Nokogiri::HTML(open(url)).xpath(xpath)
  i = 0
  page_xpath.each do |el|
    next unless !el['href'].nil? && el['href'].length > 1

    deputee_url = "http://www2.assemblee-nationale.fr#{el['href']}"
    email = get_the_email_of_a_deputee(deputee_url)
    list_deputee_mail.push({ first_name: el.text.split(' ')[1], last_name: el.text.split(' ')[2], email: email })

    i += 1
    puts "..retrieving email #{i} / 576 : #{email}"
  end

  list_deputee_mail
end

t_start = Time.now
puts get_all_the_mails_of_deputees(assemblee_url, xpath)
t_end = Time.now
puts "\nThis took #{Time.at(t_end - t_start).utc.strftime("%H:%M:%S")} to run"
