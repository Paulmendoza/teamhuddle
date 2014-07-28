class Event < ActiveRecord::Base
  
  has_one :location
  has_one :organization

  validates :name, :presence => true, :uniqueness => true
  validates :location_id, :presence => true
  validates :organization_id, :presence => true

end
