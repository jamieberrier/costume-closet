class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume
  # genre, hair_accessory, shoe, tight
  validates :dancer_id, :costume_size, :costume_condition, :dance_season, :song_name, presence: true

  # Gets current costume assignments for a dancer / dance studio
  scope :current_assignments, -> { where(dance_season: Time.now.year) }

  # Gets the costumes to display
  # dance_studios/:id/current_assignments & dance_studios/:id/current_costumes
  scope :find_costumes, -> { group(:costume_id).collect { |x| Costume.find(x.costume_id) } }

  # Gets the season's assignments for a costume
  def self.season_assignments(params)
    where("costume_id = '%s' and dance_season = '%s'", params[:id], params[:season])
  end
end
