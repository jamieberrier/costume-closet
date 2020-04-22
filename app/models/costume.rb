class Costume < ApplicationRecord
  belongs_to :dance_studio
  # adds methods, ie: costume_assignments, costume_assignments<<, costume_assignments.delete, costume_assignments_ids=ids
  has_many :costume_assignments, dependent: :delete_all # the join records will be removed when a costume is destroyed
  # adds methods, ie: dancer_ids=ids
  has_many :dancers, through: :costume_assignments

  validates :onepiece_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :onepiece_costume?
  validates :top_description, :bottoms_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :twopiece_costume?

  def onepiece_costume?
    top_description.blank? && bottoms_description.blank?
  end

  def twopiece_costume?
    onepiece_description.blank?
  end

  def twopiece_description
    top_description + ' with ' + bottoms_description
  end
  
  # TODO: refactor
  def self.find_by_assignment(assignments)
    costumes = []

    assignments.each do |assignment|
      costumes << find(assignment.costume_id)
    end
    costumes.uniq
  end

  def costume_assignments_attributes=(assignments_hashes)
    # get shared data and remove from hash
    shared = assignments_hashes.shift
    shared_attributes = shared.pop
    # delete where dancer_id == 0
    assignments_hashes.delete_if { |key, value| value[:dancer_id] == '0' }

    assignments_hashes.each do |i, unique_attributes|
      # combine unique dancer data with shared data
      combined_attributes = unique_attributes.merge(shared_attributes)
      costume_assignments.build(combined_attributes)
    end
  end

  def seasons
    costume_assignments.group(:dance_season).count
  end
end
