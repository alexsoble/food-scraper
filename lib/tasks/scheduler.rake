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
    restaurant = Restaurant.create({name: name, url: "http://www.yelp.com/#{href}", source: "Yelp"})
  end
  

  # sun_times = agent.get('http://www.suntimes.com/entertainment/dining/')
  # new_restaurants = sun_times.search("[text()*='new restaurant']")
  # new_restaurants.each do |new_restaurant|
  #   if new_restaurant.name == "p"
  #     context = new_restaurant.text[0,140]
  #     new_restaurant.parent.css('a').each do |link|
  #       pp link.attributes['href']['value']
  #     end
  #     restaurant = Restaurant.create({context: context, url: href, source: "Sun-Times"})
  #   end
  # end

  # chicagoist = agent.get('http://chicagoist.com/')

end 

task :send_scraping_email => :environment do

  UserMailer.scraping_email.deliver
    
end

task :scrape_city_portal => :environment do

  recent_inspections = HTTParty.get("http://data.cityofchicago.org/resource/4ijn-s7e5.json")[0..40]
  license_inspections = recent_inspections.reject { |i| i["inspection_type"] != "License"  || i["facility_type"] != "Restaurant" }
  license_inspections.each do |l|
    Restaurant.create({:name => l["dba_name"], :address => l["address"], :source => "City-Food"})
  end

  recent_liquor_licenses = HTTParty.get("http://data.cityofchicago.org/resource/nrmj-3kcf.json")[0..40]
  new_liquor_licenses = recent_liquor_licenses.reject { |i| i["application_type"] != "ISSUE" }
  recent_liquor_licenses.each do |l|
    Restaurant.create({:name => l["doing_business_as_name"], :address => l["address"], :source => "City-Liquor"})
  end

end