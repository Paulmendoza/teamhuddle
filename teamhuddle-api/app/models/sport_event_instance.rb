class SportEventInstance < ActiveRecord::Base
  scope :between, ->(from, to) { where("datetime_start > ? AND datetime_start < ?", from, to)}
  scope :active, -> { where("datetime_start > ? ", DateTime.now)}
  belongs_to :sport_event
  has_one :event, :through => :sport_event
  has_one :location, :through => :event
  has_one :organization, :through => :event
end
