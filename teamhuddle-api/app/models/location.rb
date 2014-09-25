class Location < ActiveRecord::Base
  
  has_many :organizations, dependent: :nullify
  has_many :events, dependent: :nullify
  has_many :sport_event_instances, :through => :event
  
  validates_associated :organizations
  validates :name, :presence => true, :uniqueness => true
end

<<-DOC

_table: locations
  _columns:
    address
    lat
    long
    name

created by: paul
last edit: paul

DOC