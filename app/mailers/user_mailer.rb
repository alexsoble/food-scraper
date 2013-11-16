# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "new-restaurants@foodscraper.com"
  after_action :mark_sent_restaurants

  def scraping_email

    @new_restaurants = Restaurant.where(:sent => false)
    @yelp_restaurants = Restaurant.where(:source => "Yelp", :sent => false)
    @city_restaurants_food = Restaurant.where(:source => "City-Food", :sent => false)
    @city_restaurants_liquor = Restaurant.where(:source => "City-Liquor", :sent => false)

    @url = "foodscraper.com"
    mail(to: "asoble@gmail.com", subject: "Report: New restaurants in Chicago")
  end

  def mark_sent_restaurants
    @new_restaurants.each do |r|
      r.sent = true
      r.save
    end
  end 

end