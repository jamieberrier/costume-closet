module DanceStudiosHelper
  def link_to_dancer_current_assignments(assignment)
    link_to Dancer.find(assignment.dancer_id).name, dancer_current_assignments_path(assignment.dancer_id)
  end

  def picture_link_to_costume_season_assignments(costume, season)
    link_to image_tag(costume.picture, width: 100), season_assignments_path(costume, season: season)
  end

  def onepiece_link_to_costume_season_assignments(costume, season)
    link_to costume.onepiece_description, season_assignments_path(costume, season: season)
  end

  def twopiece_link_to_costume_season_assignments(costume, season)
    link_to costume.twopiece_description, season_assignments_path(costume, season: season)
  end

  def assignment_info(costume)
    costume.costume_assignments.first
  end

  def costume_match(costume, assignment)
    costume.id == assignment.costume_id
  end
end
