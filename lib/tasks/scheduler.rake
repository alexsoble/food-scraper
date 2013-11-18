# encoding: utf-8

task :scrape_websites => :environment do
  require "nokogiri"
  require "httparty"
  require "mechanize" 

  agent = Mechanize.new

  yelp_cities = [
    {:name => "Chicago", :url => 'http://www.yelp.com/c/chicago/restaurants'},
    {:name => "SF Bay Area", :url => 'http://www.yelp.com/c/sf/restaurants'},
    {:name => "New York", :url => 'http://www.yelp.com/c/nyc/restaurants'}
  ]

  # yelp_cities.each do |yelp_city|
  #   yelp_page = agent.get(yelp_city[:url])
  #   rescue Mechanize::ResponseCodeError => exception
  #   if exception.response_code == '403'
  #     puts exception
  #   end
  #   new_restaurants = yelp_page.search('div.new-business-openings')
  #   new_restaurants.css('.biz-shim').each do |link|
  #     name = link.content.strip!
  #     href = link['href']
  #     @restaurant = Restaurant.new({name: name, url: "http://www.yelp.com#{href}", source: "Yelp", city: yelp_city[:name]})
  #     if @restaurant.save
  #       puts "#{@restaurant.name}, #{@restaurant.url}, #{@restaurant.city}"
  #     else
  #       puts "Restaurant name already in database"
  #     end
  #   end
  # end

  urbanspoon_cities = [
    {:name => "Chicago", :url => "http://www.urbanspoon.com/lb/2/best-restaurants-Chicago?sort=date"},
    {:name => "SF Bay Area", :url => "http://www.urbanspoon.com/lb/6/best-restaurants-SF-Bay-Area?sort=date"},
    {:name => "New York", :url => "http://www.urbanspoon.com/lb/3/best-restaurants-New-York?sort=date"}
  ]
  urbanspoon_cities.each do |urbanspoon_city|
    urbanspoon_page = agent.get(urbanspoon_city[:url])
    new_restaurants = urbanspoon_page.search('div.list.restaurants')
    new_restaurant_list = new_restaurants.children.css('ul')
    new_restaurant_list.children[0..12].each do |new_restaurant|
      new_restaurant_link = new_restaurant.css('a.resto_name')
      if new_restaurant_link.present?
        name = new_restaurant_link.text
        href = new_restaurant_link.attr('href')
        @restaurant = Restaurant.new({name: name, url: "http://www.urbanspoon.com#{href}", source: "Urbanspoon", city: urbanspoon_city[:name]})
        if @restaurant.save
          puts "#{@restaurant.name}, #{@restaurant.url}, #{@restaurant.city}"
        else
          puts "Restaurant name already in database"
        end
      end
    end
  end

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

task :send_scraping_email => :environment do

  UserMailer.scraping_email.deliver
    
end
