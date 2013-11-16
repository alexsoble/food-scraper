class Restaurant < ActiveRecord::Base
  attr_accessible :name, :address, :source, :url, :context
  validates_presence_of :source, :name
  validates_uniqueness_of :name
end
