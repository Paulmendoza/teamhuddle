class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_event

  validates :rating, :presence => true, :numericality => {:greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :user_id, :presence => true
  validates :sport_event_id, :presence => true

  validate :unique_user_review

  def unique_user_review
    if Review.where(user_id: self.user_id, sport_event_id: self.sport_event_id).any?
      errors.add(:not_unique_review, "the user has already reviewed this droping")
    end
  end

end
