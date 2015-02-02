class BetaTester < ActiveRecord::Base
  validates :email, :uniqueness => true

end
