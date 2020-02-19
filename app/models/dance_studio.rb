class DanceStudio < ApplicationRecord
  has_many :dancers
  has_many :costumes
  has_secure_password
end
