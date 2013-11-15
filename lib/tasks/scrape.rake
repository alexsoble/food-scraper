# encoding: utf-8

task :scrape => :environment do

  UserMailer.scraping_email.deliver
    
end