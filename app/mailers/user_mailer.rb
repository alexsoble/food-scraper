# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "new-restaurants@foodscraper.com"
  
  def scraping_email

    @yelp_restaurants = Restaurant.where(:source => "Yelp")

    @url = "foodscraper.com"
    mail(to: "asoble@gmail.com", subject: "Report: New restaurants in Chicago")
  end

end