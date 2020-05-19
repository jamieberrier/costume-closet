module DanceStudiosHelper
  def link_to_dancer_current_assignments(assignment)
    link_to full_name(Dancer.find(assignment.dancer_id)), dancer_current_assignments_path(assignment.dancer_id)
  end

  def assignment_info(costume)
    costume.costume_assignments.first
  end

  def uppercase_song_name(info)
    info.song_name.upcase
  end

  def costume_match(costume, assignment)
    costume.id == assignment.costume_id
  end

  def current_year
    Time.now.year
  end
end
