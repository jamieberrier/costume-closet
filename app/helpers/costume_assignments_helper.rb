module CostumeAssignmentsHelper
  def song_name_link(assignment)
    link_to_if owner?, assignment.song_name, season_assignments_path(assignment.costume_id, season: assignment.dance_season) do |name|
      link_to name, costume_path(assignment.costume_id)
    end
  end

  def dancer_name_link(assignment)
    link_to full_name(Dancer.find(assignment.dancer_id)), dancer_costumes_path(assignment.dancer_id, dancer_id: assignment.dancer_id) 
  end
end
