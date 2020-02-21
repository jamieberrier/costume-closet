class DanceStudio < ApplicationRecord
  has_many :dancers
  has_many :costumes

  has_secure_password
  validates :password, confirmation: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :studio_name, :owner_name, :password_confirmation, presence: true

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.owner_name = auth.info.name
      user.email = auth.info.email
    end
  end
end
