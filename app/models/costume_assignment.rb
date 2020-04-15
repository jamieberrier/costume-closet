class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume
  # costume_size, genre, shoe, tight, costume_condition
  validates :dancer_id, :costume_id, :dance_season, :song_name, presence: true

  # Gets current costume assignments for a dancer
  scope :current_dancer_costumes, lambda { |dancer| where(["dancer_id = '%s' and dance_season = '%s'", dancer.id, Time.now.year]) }
end
