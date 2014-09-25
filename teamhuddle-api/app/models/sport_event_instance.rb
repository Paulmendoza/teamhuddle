class SportEventInstance < ActiveRecord::Base
  scope :between, ->(from, to) { where("datetime_start > ? AND datetime_start < ?", from, to)}
  belongs_to :sport_event
  belongs_to :event
  has_one :location, :through => :event
end
