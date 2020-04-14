class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume

  # Gets current costume assignments for a dancer
  scope :current_dancer_costumes, lambda { |dancer| where(["dancer_id = '%s' and dance_season = '%s'", dancer.id, Time.now.year]) }

end
