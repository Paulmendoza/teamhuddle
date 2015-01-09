class SportEventInstance < ActiveRecord::Base
  scope :between, ->(from, to) { where("datetime_start > ? AND datetime_start < ?", from, to)}
  scope :active, -> { where("datetime_start > ? ", DateTime.now)}
  belongs_to :sport_event
  belongs_to :event
  has_one :location, :through => :event
  has_one :organization, :through => :event
end
