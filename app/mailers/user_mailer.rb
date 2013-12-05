# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "food.scraper.bot@gmail.com"

  def scraping_email(test)

    unless Time.now.sunday? || Time.now.saturday? 
      
      @new_restaurants = Restaurant.where(:sent => false).group_by(&:city)
      @cities = @new_restaurants.keys

      # @chicago = Restaurant.where(:city => "Chicago", :sent => false)
      # @nyc = Restaurant.where(:city => "New York", :sent => false)
      # @sf = Restaurant.where(:city => "SF Bay Area", :sent => false)

      # @yelp_restaurants_chi = Restaurant.where(:source => "Yelp", :city => "Chicago", :sent => false)
      # @urbanspoon_restaurants_chi = Restaurant.where(:source => "Urbanspoon", :city => "Chicago", :sent => false)
      # @yelp_restaurants_nyc = Restaurant.where(:source => "Yelp", :city => "New York", :sent => false)
      # @urbanspoon_restaurants_nyc = Restaurant.where(:source => "Urbanspoon", :city => "New York", :sent => false)
      # @yelp_restaurants_sf = Restaurant.where(:source => "Yelp", :city => "SF Bay Area", :sent => false)
      # @urbanspoon_restaurants_sf = Restaurant.where(:source => "Urbanspoon", :city => "SF Bay Area", :sent => false)

      # @urbanspoon_restaurants_boston = Restaurant.where(:source => "Urbanspoon", :city => "Boston", :sent => false)
      # @urbanspoon_restaurants_la = Restaurant.where(:source => "Urbanspoon", :city => "L.A.", :sent => false)
      # @urbanspoon_restaurants_dc = Restaurant.where(:source => "Urbanspoon", :city => "Washington, D.C.", :sent => false)
      # @urbanspoon_restaurants_denver = Restaurant.where(:source => "Urbanspoon", :city => "Denver", :sent => false)
      # @urbanspoon_restaurants_birmingham = Restaurant.where(:source => "Urbanspoon", :city => "Birmingham", :sent => false)

      # @city_restaurants_food = Restaurant.where(:source => "City-Food", :sent => false)
      # @city_restaurants_liquor = Restaurant.where(:source => "City-Liquor", :sent => false)

      @url = "foodscraper.com"
      @today = Time.now.strftime("%m/%e/%y")

      if test == true 
        mail(to: "asoble@gmail.com", subject: "Report: New restaurants #{@today}")
      else
        mail(to: "breadcrumb-leadgen@groupon.com", cc: ["asoble@gmail.com", "annie@breadcrumb.com"], subject: "Report: New restaurants #{@today}")
        @new_restaurants.each do |r|
          r.sent = true
          r.save
        end
      end

    end
  
  end

end