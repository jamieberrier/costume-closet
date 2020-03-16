class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume

  def self.current_studio_costumes(studio)
    studio.costume_assignments.where("dance_season = '%s'", Time.now.year)
  end

  #  SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
  def self.current_costumes(dancer)
    where(["dancer_id = '%s' and dance_season = '%s'", dancer.id, Time.now.year])
  end
end
