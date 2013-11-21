# encoding: utf-8

task :scrape_urbanspoon => :environment do
  require "nokogiri"
  require "httparty"
  require "mechanize" 

  agent = Mechanize.new

  urbanspoon_cities = [
    {:name => "Chicago", :url => "http://www.urbanspoon.com/lb/2/best-restaurants-Chicago?sort=date"},
    {:name => "SF Bay Area", :url => "http://www.urbanspoon.com/lb/6/best-restaurants-SF-Bay-Area?sort=date"},
    {:name => "New York", :url => "http://www.urbanspoon.com/lb/3/best-restaurants-New-York?sort=date"},
    {:name => "Boston", :url => "http://www.urbanspoon.com/lb/4/best-restaurants-Boston?sort=date"},
    {:name => "L.A.", :url => "http://www.urbanspoon.com/lb/5/best-restaurants-Los-Angeles?sort=date"},
    {:name => "Washington, D.C.", :url => "http://www.urbanspoon.com/lb/7/best-restaurants-Washington-DC?sort=date"},
    {:name => "Denver", :url => "http://www.urbanspoon.com/lb/17/best-restaurants-Denver?sort=date"},
    {:name => "Birmingham", :url => "http://www.urbanspoon.com/lb/45/best-restaurants-Birmingham?sort=date"}
  ]
  urbanspoon_cities.each do |urbanspoon_city|
    urbanspoon_page = agent.get(urbanspoon_city[:url])
    new_restaurants = urbanspoon_page.search('div.list.restaurants')
    new_restaurant_list = new_restaurants.children.css('ul')
    new_restaurant_list.children[0..9].each do |new_restaurant|
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

task :scrape_yelp => :environment do

  require "nokogiri"
  require "httparty"
  require "mechanize" 

  agent = Mechanize.new

  yelp_cities = [
    {:name => "Chicago", :url => 'http://www.yelp.com/c/chicago/restaurants'},
    {:name => "SF Bay Area", :url => 'http://www.yelp.com/c/sf/restaurants'},
    {:name => "New York", :url => 'http://www.yelp.com/c/nyc/restaurants'}
  ]

  yelp_cities.each do |yelp_city|
    yelp_page = agent.get(yelp_city[:url])
    new_restaurants = yelp_page.search('div.new-business-openings')
    new_restaurants.css('.biz-shim').each do |link|
      name = link.content.strip!
      href = link['href']
      @restaurant = Restaurant.new({name: name, url: "http://www.yelp.com#{href}", source: "Yelp", city: yelp_city[:name]})
      if @restaurant.save
        puts "#{@restaurant.name}, #{@restaurant.url}, #{@restaurant.city}"
      else
        puts "Restaurant name already in database"
      end
    end
  end
end

task :scrape_city_portal => :environment do

  @today = Time.now.strftime("%Y-%m-%d")
  @yesterday = Time.now.yesterday.strftime("%Y-%m-%d")

  recent_inspections = HTTParty.get("http://data.cityofchicago.org/resource/4ijn-s7e5.json?$where=inspection_date='#{@yesterday}T00:00:00'")
  recent_inspections = JSON.parse(recent_inspections.body)
  recent_inspections = recent_inspections.reject { |i| i["inspection_type"] != "License" || i["facility_type"] != "Restaurant" }
  
  recent_inspections.each do |l|
    @restaurant = Restaurant.new({:name => l["dba_name"], :address => l["address"], :source => "City-Food", :city => "Chicago"})
    if @restaurant.save
      puts "#{@restaurant.name}, #{@restaurant.city}"
    else
      puts "Restaurant name already in database"
    end
  end

  recent_liquor_licenses = HTTParty.get("http://data.cityofchicago.org/resource/nrmj-3kcf.json?$where=date_issued='#{@yesterday}T00:00:00'")
  recent_liquor_licenses = JSON.parse(recent_liquor_licenses.body)
  recent_liquor_licenses = recent_liquor_licenses.reject { |l| l["application_type"] != "ISSUE" }

  recent_liquor_licenses.each do |l|
    @restaurant = Restaurant.new({:name => l["doing_business_as_name"], :address => l["address"], :source => "City-Liquor", :city => "Chicago"})
    if @restaurant.save
      puts "#{@restaurant.name}, #{@restaurant.city}"
    else
      puts "Restaurant name already in database"
    end
  end

end

task :send_scraping_email => :environment do

  UserMailer.scraping_email.deliver
    
end
