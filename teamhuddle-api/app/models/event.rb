class Event < ActiveRecord::Base
  
  has_one :location
  has_one :organization
  has_one :sport_event, :dependent => :delete

  validates :name, :presence => true, :uniqueness => true
  validates :location_id, :presence => true
  validates :organization_id, :presence => true

end
