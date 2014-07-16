class Organization < ActiveRecord::Base
  has_one :user
  has_one :location
end
