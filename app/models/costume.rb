class Costume < ApplicationRecord
  belongs_to :dance_studio
  # adds methods, ie: costume_assignments, costume_assignments<<, costume_assignments.delete, costume_assignments_ids=ids
  has_many :costume_assignments, dependent: :delete_all # join records removed when costume destroyed
  # adds methods, ie: dancer_ids=ids
  has_many :dancers, through: :costume_assignments

  validates :onepiece_description, presence: { message: '- Must enter a onepiece description if one-piece costume' }, if: :twopiece_blank?
  validates :top_description, :bottoms_description, presence: { message: '- Must enter a top AND bottoms description if two-piece costume' }, if: :onepiece_blank?
  validates :onepiece_description, absence: { message: '- One-piece description must be blank if Two-piece costume' }, if: :twopiece_costume?
  validates :top_description, :bottoms_description, absence: { message: '- Two-piece description must be blank if One-piece costume' }, if: :onepiece_costume?

  # Returns true if onepiece_description is blank
  def onepiece_blank?
    onepiece_description.blank?
  end

  # Returns true if top_description & bottoms_description are blank
  def twopiece_blank?
    top_description.blank? && bottoms_description.blank?
  end

  # Returns true if onepiece_description is filled in
  def onepiece_costume?
    onepiece_description.present?
  end

  # Returns true if top_description & bottoms_description are filled in
  def twopiece_costume?
    top_description.present? && bottoms_description.present?
  end

  # Concatenates the top description w/ the bottoms description for displaying
  def twopiece_description
    top_description + ' with ' + bottoms_description
  end

  # Gets the costume's assigned seasons w/ no. of assignments per season
  def seasons
    costume_assignments.group(:dance_season).count
  end

  # instanstiates an empty instance of costume assignment to collect the shared data for the assignments
  def build_shared_assignment_info
    costume_assignments.build
  end

  # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
  def build_assignments_with_dancer_id(studio)
    studio.dancers.current_dancers.each do |dancer|
      costume_assignments.build(dancer_id: dancer.id)
    end
  end

  # build a costume_assignments record unless one with dancer's id already exists
  def build_assignments_unless_exists(studio, assignments)
    studio.dancers.current_dancers.each do |dancer|
      costume_assignments.build(dancer_id: dancer.id) unless assignments.exists?(dancer_id: dancer.id)
    end
  end

  # instanstiates an instance of costume assignment with shared assignment info to edit
  # edit_season_assignments action
  def shared_assignment_info(assignment)
    costume_assignments.build(hair_accessory: assignment.hair_accessory, tight: assignment.tight, shoe: assignment.shoe, genre: assignment.genre, song_name: assignment.song_name, costume_id: id, dance_season: assignment.dance_season, id: nil, dancer_id: nil, costume_size: nil, costume_condition: nil)
  end

  def costume_assignments_attributes=(assignments_hashes)
    # get shared data and remove from hash (song_name, genre, etc.)
    shared_attributes = assignments_hashes.shift.pop
    # delete unselected dancers
    assignments_hashes.keep_if { |_i, unique_attributes| unique_attributes[:id] || unique_attributes[:dancer_id] != '0' }

    assignments_hashes.each do |_i, unique_attributes|
      if unique_attributes[:id] && unique_attributes[:dancer_id] == '0'
        # edit: if dancer unselected, delete record in costume assignments
        CostumeAssignment.find(unique_attributes[:id]).destroy
      else # create or update record
        # combine unique dancer data with shared data
        combined_attributes = unique_attributes.merge(shared_attributes)
        # if new, else editing
        combined_attributes[:id].nil? ? costume_assignments.build(combined_attributes) : costume_assignments.find(combined_attributes[:id]).update(combined_attributes)
      end
    end
  end
end

=begin

 new
    assignments_hashes
=> {"0"=>
  {"song_name"=>"Golden",
    "dance_season"=>"2020",
    "genre"=>"lyrical",
    "hair_accessory"=>"none",
    "shoe"=>"none",
    "tight"=>"none"},
 "8"=>{"dancer_id"=>"0", "costume_size"=>""},
 "9"=>{"dancer_id"=>"0", "costume_size"=>""},
 "10"=>{"dancer_id"=>"0", "costume_size"=>""},
 "11"=>{"dancer_id"=>"4", "costume_size"=>"M"},
 "12"=>{"dancer_id"=>"5", "costume_size"=>"M"},
 "13"=>{"dancer_id"=>"0", "costume_size"=>""}}

assign
  assignments_hashes
=> {"1"=>
  {"song_name"=>"Swan Lake",
   "dance_season"=>"2020",
   "genre"=>"ballet",
   "hair_accessory"=>"tiara",
   "shoe"=>"pink ballet",
   "tight"=>"pink footed"},
 "10"=>{"dancer_id"=>"1", "costume_size"=>"S", "costume_condition"=>"Used"},
 "11"=>{"dancer_id"=>"2", "costume_size"=>"S", "costume_condition"=>"New"},
 "12"=>{"dancer_id"=>"0", "costume_size"=>"", "costume_condition"=>""},
 "13"=>{"dancer_id"=>"0", "costume_size"=>"", "costume_condition"=>""},
 "14"=>{"dancer_id"=>"0", "costume_size"=>"", "costume_condition"=>""},
 "15"=>{"dancer_id"=>"15", "costume_size"=>"M", "costume_condition"=>"New"}}

edit season assignments
  assignments_hashes
=> {"4"=>
  {"song_name"=>"Swan Lake",
   "dance_season"=>"2020",
   "genre"=>"ballet",
   "hair_accessory"=>"tiara",
   "shoe"=>"pink ballet",
   "tight"=>"pink footed"},
 "9"=>{"id"=>"27", "dancer_id"=>"1", "costume_size"=>"S", "costume_condition"=>"Used"},
 "10"=>{"id"=>"28", "dancer_id"=>"2", "costume_size"=>"S", "costume_condition"=>"New"},
 "11"=>{"id"=>"29", "dancer_id"=>"0", "costume_size"=>"M", "costume_condition"=>"New"},
 "21"=>{"dancer_id"=>"3", "costume_size"=>"M", "costume_condition"=>"New"},
 "22"=>{"dancer_id"=>"0", "costume_size"=>"", "costume_condition"=>""},
 "23"=>{"dancer_id"=>"0", "costume_size"=>"", "costume_condition"=>""}}
=end
