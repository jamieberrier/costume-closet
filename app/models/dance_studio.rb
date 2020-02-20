class DanceStudio < ApplicationRecord
  has_many :dancers
  has_many :costumes

  has_secure_password
  validates :password, confirmation: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :studio_name, :owner_name, :password_confirmation, presence: true
end
