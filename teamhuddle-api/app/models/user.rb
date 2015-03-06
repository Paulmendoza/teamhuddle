class User < ActiveRecord::Base

  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :rememberable, :trackable, :registerable, :omniauthable, :omniauth_providers => [:facebook]

  def full_name
    first_name + ' ' + last_name
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.image_url = auth.info.image
    end
  end
end
