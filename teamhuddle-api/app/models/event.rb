class Event < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :organization
  has_many :sport_event, :dependent => :delete_all
  has_many :sport_event_instance, :dependent => :delete_all

  validates :location_id, :presence => true
  validates :organization_id, :presence => true

end
