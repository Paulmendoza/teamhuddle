class Event < ActiveRecord::Base
  has_one :location
  has_one :organization
end
