class Restaurant < ActiveRecord::Base
  attr_accessible :name, :address, :source, :url, :context, :city
  validates_presence_of :source, :name
  validates_uniqueness_of :name
end
