class Costume < ApplicationRecord
  belongs_to :dance_studio
  has_many :costume_assignments
  has_many :dancers, through: :costume_assignments
end
