class SportEventInstance < ActiveRecord::Base
  scope :occurs_on, ->(date) { where("datetime_start > ? AND datetime_start < ?", date.beginning_of_day, date.end_of_day)}
  belongs_to :sport_event
  belongs_to :event
end
