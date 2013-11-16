# encoding: utf-8

task :scrape_websites => :environment do
  require "nokogiri"
  require "httparty"
  require "mechanize" 

  agent = Mechanize.new

  yelp_page = agent.get('http://www.yelp.com/c/chicago/restaurants')
  new_restaurants = yelp_page.search('div.new-business-openings')
  new_restaurants.css('.biz-shim').each do |link|
    name = link.content.strip!
    href = link['href']
    @restaurant = Restaurant.create({name: name, url: "http://www.yelp.com#{href}", source: "Yelp"})
  end 

  urbanspoon = agent.get('http://www.urbanspoon.com/lb/2/best-restaurants-Chicago?sort=date')
  new_restaurants = urbanspoon.search('div.list.restaurants')
  new_restaurant_list = new_restaurants.children[1]
  new_restaurant_list.children[0..8].each do |new_restaurant|
    new_restaurant_link = new_restaurant.css('a.resto_name')
    if new_restaurant_link.present?
      name = new_restaurant_link.text.strip!
      href = new_restaurant_link.attr('href')
      @restaurant = Restaurant.create({name: name, url: "http://www.urbanspoon.com#{href}", source: "Urbanspoon"})
    end
  end

end 

task :send_scraping_email => :environment do

  UserMailer.scraping_email.deliver
    
end

task :scrape_city_portal => :environment do

  recent_inspections = HTTParty.get("http://data.cityofchicago.org/resource/4ijn-s7e5.json")[0..40]
  license_inspections = recent_inspections.reject { |i| i["inspection_type"] != "License"  || i["facility_type"] != "Restaurant" }
  license_inspections.each do |l|
    @restaurant = Restaurant.create({:name => l["dba_name"], :address => l["address"], :source => "City-Food"})
    puts @restaurant
  end

  recent_liquor_licenses = HTTParty.get("http://data.cityofchicago.org/resource/nrmj-3kcf.json")[0..40]
  new_liquor_licenses = recent_liquor_licenses.reject { |i| i["application_type"] != "ISSUE" }
  recent_liquor_licenses.each do |l|
    @restaurant = Restaurant.create({:name => l["doing_business_as_name"], :address => l["address"], :source => "City-Liquor"})
    puts @restaurant
  end

end