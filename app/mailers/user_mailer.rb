# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "food.scraper.bot@gmail.com"

  def scraping_email(test)

    unless Time.now.sunday? || Time.now.saturday? 
      
      @new_restaurants_unsorted = Restaurant.where(:sent => false)
      @new_restaurants = @new_restaurants_unsorted.group_by(&:city)
      @cities = @new_restaurants.keys.sort

      @url = "foodscraper.com"
      @today = Time.now.strftime("%m/%e/%y")

      if test == true 
        mail(to: "asoble@gmail.com", subject: "Report: New restaurants #{@today}")
      else
        mail(to: "breadcrumb-leadgen@groupon.com", cc: ["asoble@gmail.com", "annie@breadcrumb.com"], subject: "Report: New restaurants #{@today}")
        @new_restaurants_unsorted.each do |r|
          r.sent = true
          r.save
        end
      end

    end
  
  end

end