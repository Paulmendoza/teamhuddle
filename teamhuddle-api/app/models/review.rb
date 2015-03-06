class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_event

  validates :rating, :presence => true, :numericality => {:greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :user_id, :presence => true
  validates :sport_event_id, :presence => true

end
