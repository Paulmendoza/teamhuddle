class Event < ActiveRecord::Base
  
  belongs_to :location
  has_one :organization
  has_one :sport_event, :dependent => :delete
  has_many :sport_event_instance, :dependent => :delete_all

  validates :name, :presence => true, :uniqueness => true
  validates :location_id, :presence => true
  validates :organization_id, :presence => true

end
