class Restaurant < ActiveRecord::Base
  attr_accessible :name, :address, :source, :url
  validates_presence_of :name, :source
  validates_uniqueness_of :name
end
