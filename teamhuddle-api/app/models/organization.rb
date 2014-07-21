class Organization < ActiveRecord::Base
  #
  after_initialize :init

  #
  validates :name, :presence => true, :uniqueness => true
  validates :email, :uniqueness => true, allow_nil: true
  
  # exposes associated objects
  def location
    Location.where( id: self.location_id )
  end

  def user
    User.where( id: self.user_id )
  end

  #
  private
  def init
  end

end

<<-DOC

_table: organizations
  _columns:
    name
    location_id
    user_id
    phone
    email
    created_at
    updated_at

created by: paul
last edit: paul

DOC