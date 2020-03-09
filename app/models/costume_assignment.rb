class CostumeAssignment < ApplicationRecord
  belongs_to :dancer
  belongs_to :costume

  def self.current_studio_costumes(studio)
    assignments = where(dance_season: Time.now.year)
    costume_ids = []
    costumes = []

    assignments.each do |assignment|
      costume_ids << assignment.costume_id
    end

    costume_ids.uniq!.each do |costume_id|
      costumes << Costume.find(costume_id)
      costumes.reject! { |costume| costume.dance_studio_id != studio.id }
    end

    costumes
  end

  #  SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
  def self.current_costumes(dancer)
    where(["dancer_id = '%s' and dance_season = '%s'", dancer.id, Time.now.year])
  end
end
