# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "new-restaurants@foodscraper.com"

  def scraping_email
    @url = 'http://foodscraper.com',
    mail(to: "asoble@gmail.com",  subject: 'Repot: New restaurants in Chicago')
  end
end