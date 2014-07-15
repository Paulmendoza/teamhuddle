class SportEvent < ActiveRecord::Base
  belongs_to :event
  has_many :archived_sport_events
  has_many :sport_events
end
