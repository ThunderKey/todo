class User < ApplicationRecord
  devise :database_authenticatable, :trackable,
    :omniauthable, :omniauth_providers => [:keltec]

  validates :email, presence: true, uniqueness: true
  validates :lastname, presence: true
  validates :firstname, presence: true

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
