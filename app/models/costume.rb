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
=begin
edit season assignments
  assignments_hashes
=> {"5"=>
  {"song_name"=>"test",
   "dance_season"=>"2020",
   "genre"=>"lyrical",
   "hair_accessory"=>"none",
   "shoe"=>"none",
   "tight"=>"none"},
 "6"=>{"id"=>"25", "dancer_id"=>"0", "costume_size"=>"M"},
 "7"=>{"id"=>"26", "dancer_id"=>"2", "costume_size"=>"XS"},
 "8"=>{"id"=>"27", "dancer_id"=>"3", "costume_size"=>"S"},
 "9"=>{"id"=>"28", "dancer_id"=>"4", "costume_size"=>"M"},
 "10"=>{"id"=>"29", "dancer_id"=>"5", "costume_size"=>"M"}}

 new
    assignments_hashes
=> {"0"=>
  {"song_name"=>"test",
   "dance_season"=>"2020",
   "genre"=>"lyrical",
   "hair_accessory"=>"none",
   "shoe"=>"none",
   "tight"=>"none"},
 "7"=>{"dancer_id"=>"0", "costume_size"=>""},
 "8"=>{"dancer_id"=>"0", "costume_size"=>""},
 "9"=>{"dancer_id"=>"3", "costume_size"=>"S"},
 "10"=>{"dancer_id"=>"0", "costume_size"=>""},
 "11"=>{"dancer_id"=>"0", "costume_size"=>""}}
=end

  def costume_assignments_attributes=(assignments_hashes)
    # get shared data and remove from hash
    shared_attributes = assignments_hashes.shift.pop
    # delete unselected dancers, where dancer_id == 0
    assignments_hashes.delete_if { |key, value| value[:dancer_id] == '0' }

    assignments_hashes.each do |i, unique_attributes|
      # combine unique dancer data with shared data
      combined_attributes = unique_attributes.merge(shared_attributes)
      # new
      if combined_attributes[:id].nil?
        costume_assignments.build(combined_attributes)
      else # editing
        costume_assignments.find(combined_attributes[:id]).update(combined_attributes)
      end
    end
  end

  def seasons
    costume_assignments.group(:dance_season).count
  end
end
