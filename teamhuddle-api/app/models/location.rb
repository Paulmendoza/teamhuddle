class Location < ActiveRecord::Base
  
  has_many :organizations
  has_many :events

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