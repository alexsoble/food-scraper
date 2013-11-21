class Restaurant < ActiveRecord::Base
  attr_accessible :sent, :name, :address, :source, :url, :context, :city, :phone
  validates_presence_of :source, :name
  validates_uniqueness_of :name

  def get_phone
    require "nokogiri"
    require "httparty"
    require "mechanize" 

    if self.source == "Urbanspoon" && self.url.present?
      agent = Mechanize.new
      page = agent.get(self.url)
      phone = page.search('div.phone.tel').text
      self.update_attributes(:phone => phone)
    end 

  end

end
