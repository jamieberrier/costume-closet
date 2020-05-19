module DancersHelper
  # Concatenates a dancer's first and last name
  def full_name(dancer)
    dancer.first_name + ' ' + dancer.last_name
  end

  def assignment_costume(assignment)
    Costume.find(assignment.costume_id)
  end

  def current?(dancer)
    dancer.current_dancer ? 'YES' : 'NO'
  end

  def current_assignments_count(dancer)
    dancer.costume_assignments.current_assignments.count
  end

  def all_assignments_count(dancer)
    dancer.costume_assignments.count
  end

  def current_studio_costumes_count
    current_user.current_studio_costumes.count
  end

  def costumes_count(user_type)
    user_type.costumes.count
  end
end
