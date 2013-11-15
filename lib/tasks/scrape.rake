# encoding: utf-8

task :scrape => :environment do
  require "nokogiri"
  require "mechanize" 

  agent = Mechanize.new
  yelp_page = agent.get('http://www.yelp.com/c/chicago/restaurants')
  new_restaurants = yelp_page.search('div.new-business-openings')
  new_restaurants.css('.biz-shim').each do |link|
    name = link.content.strip!
    puts name
    href = link['href']
    puts href
    restaurant = Restaurant.create({name: name, url: "http://www.yelp.com/#{href}", source: "Yelp"})
    puts restaurant
  end
  
  UserMailer.scraping_email.deliver
    
end