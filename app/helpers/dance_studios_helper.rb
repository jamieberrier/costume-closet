module DanceStudiosHelper
  def link_to_dancer_current_assignments(assignment)
    link_to Dancer.find(assignment.dancer_id).name, dancer_current_assignments_path(assignment.dancer_id)
  end

  def assignment_info(costume)
    costume.costume_assignments.first
  end

  def costume_match(costume, assignment)
    costume.id == assignment.costume_id
  end
end
