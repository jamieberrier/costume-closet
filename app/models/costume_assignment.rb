class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume
  # genre, hair_accessory, shoe, tight
  validates :dancer_id, :costume_size, :costume_condition, :dance_season, :song_name, presence: true

  # Gets current costume assignments for a dancer
  scope :current_dancer_costumes, lambda { |dancer| where(["dancer_id = '%s' and dance_season = '%s'", dancer.id, Time.now.year]) }
end
