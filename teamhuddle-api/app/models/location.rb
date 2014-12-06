class Location < ActiveRecord::Base
  before_destroy :check_event_references

  has_many :organizations, dependent: :nullify
  has_many :events, dependent: :nullify
  has_many :sport_events, :through => :event
  has_many :sport_event_instances, :through => :event

  def check_event_references
    return true if events.count == 0

    errors.add :event_reference_found, 'Cannot delete location with events linked to it'

    return false
  end

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