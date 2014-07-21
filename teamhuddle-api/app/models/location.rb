class Location < ActiveRecord::Base
  
  has_many :organizations
  has_many :events

  validates :name, :presence => true, :uniqueness => true
end
