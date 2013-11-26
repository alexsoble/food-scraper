class Restaurant < ActiveRecord::Base
  attr_accessible :sent, :name, :address, :source, :url, :context, :city, :phone
  validates_presence_of :source, :name
  validates_uniqueness_of :name

  def get_phone
    require "nokogiri"
    require "httparty"
    require "mechanize" 

    if self.url.present?
      agent = Mechanize.new
      page = agent.get(self.url)
      if self.source == "Urbanspoon"
        phone = page.search('div.phone.tel').text
        if phone.present?
          self.update_attributes(:phone => phone)
        end
      elsif self.source == "Yelp"
        phone = page.search('span#bizPhone').text
        if phone.present?
          self.update_attributes(:phone => phone)
        end
      end
    end 
  end

  def get_website
    require "nokogiri"
    require "httparty"
    require "mechanize" 

    # if self.url.present?
    #   agent = Mechanize.new
    #   page = agent.get(self.url)
    #   if self.source == "Urbanspoon"
    #     phone = page.search('div.phone.tel').text
    #     if phone.present?
    #       self.update_attributes(:phone => phone)
    #     end
    #   elsif self.source == "Yelp"
    #     phone = page.search('span#bizPhone').text
    #     if phone.present?
    #       self.update_attributes(:phone => phone)
    #     end
    #   end
    # end 
  end
end
