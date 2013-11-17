# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "new-restaurants@foodscraper.com"

  def scraping_email

    unless Time.now.sunday? || Time.now.saturday? 
      
      @new_restaurants = Restaurant.where(:sent => false)

      @chicago = Restaurant.where(:city => "Chicago", :sent => false)
      @nyc = Restaurant.where(:city => "New York", :sent => false)
      @sf = Restaurant.where(:city => "SF Bay Area", :sent => false)

      @yelp_restaurants_chi = Restaurant.where(:source => "Yelp", :city => "Chicago", :sent => false)
      @urbanspoon_restaurants_chi = Restaurant.where(:source => "Urbanspoon", :city => "Chicago", :sent => false)
      @yelp_restaurants_nyc = Restaurant.where(:source => "Yelp", :city => "New York", :sent => false)
      @urbanspoon_restaurants_nyc = Restaurant.where(:source => "Urbanspoon", :city => "New York", :sent => false)
      @yelp_restaurants_sf = Restaurant.where(:source => "Yelp", :city => "SF Bay Area", :sent => false)
      @urbanspoon_restaurants_sf = Restaurant.where(:source => "Urbanspoon", :city => "SF Bay Area", :sent => false)

      @city_restaurants_food = Restaurant.where(:source => "City-Food", :sent => false)
      @city_restaurants_liquor = Restaurant.where(:source => "City-Liquor", :sent => false)

      @url = "foodscraper.com"
      @today = Time.now.strftime("%m/%e/%y")

      mail(to: "asoble@gmail.com", subject: "Report: New restaurants #{@today}")

      @new_restaurants.each do |r|
        r.sent = true
        r.save
      end

    end
  
  end

end