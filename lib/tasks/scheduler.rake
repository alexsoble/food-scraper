# encoding: utf-8

task :scrape => :environment do
  require "nokogiri"
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