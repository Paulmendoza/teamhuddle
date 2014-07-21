class Event < ActiveRecord::Base
  
  has_one :location
  has_one :organization

  validates :name, :presence => true, :uniqueness => true
  validates :location, :presence => true
  validates :organization, :presence => true

end
