class User < ApplicationRecord
  devise :database_authenticatable, :trackable,
    :omniauthable, :omniauth_providers => [:keltec]

  validates :email, presence: true, uniqueness: true
  validates :lastname, presence: true
  validates :firstname, presence: true
  validate do
    if time_zone.blank?
      errors.add :time_zone, :blank
    elsif ActiveSupport::TimeZone[time_zone].nil?
      errors.add :time_zone, :invalid
    end
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email = auth.info.email
    user.lastname = auth.info.lastname
    user.firstname = auth.info.firstname
    user.save!
    user
  end

  has_many :todo_lists
end
