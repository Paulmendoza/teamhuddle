class Sport < ActiveRecord::Base
  self.primary_key = 'sport'
  
  has_many :sport_events
end
