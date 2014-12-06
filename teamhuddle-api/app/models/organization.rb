class Organization < ActiveRecord::Base

  before_destroy :check_event_references

  belongs_to :location
  has_many :events

  validates :name, :presence => true, :uniqueness => true
  validates :email, :uniqueness => true, :allow_nil => true
  validates :location_id, :inclusion => { :in => Location.pluck(:id),
    :message => "not a valid location" }, :allow_nil => true

  def check_event_references
    return true if events.count == 0

    errors.add :event_reference_found, 'Cannot delete organization with events linked to it'

    return false
  end

end

<<-DOC

_table: organizations
  _columns:
    name
    location_id
    user_id
    phone
    email
    created_at
    updated_at

created by: paul
last edit: paul

DOC