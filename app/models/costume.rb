class Costume < ApplicationRecord
  belongs_to :dance_studio
  has_many :costume_assignments
  has_many :dancers, through: :costume_assignments

  validates :onepiece_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :onepiece_costume?
  validates :top_description, :bottoms_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :twopiece_costume?

  def onepiece_costume?
    top_description.blank? && bottoms_description.blank?
  end

  def twopiece_costume?
    onepiece_description.blank?
  end

  def self.find_by_assignment(assignments)
    costumes = []
    assignments.each do |assignment|
      costumes << Costume.find(assignment.costume_id)
    end
    costumes.uniq
  end
end
