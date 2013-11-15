class Restaurant < ActiveRecord::Base
  attr_accessible :name, :address, :source, :url, :context
  validates_presence_of :source, :url
  validates_uniqueness_of :name
end
