module DancersHelper
  # Concatenates a dancer's first and last name
  def full_name(dancer)
    dancer.first_name + ' ' + dancer.last_name
  end

  def assignment_costume(assignment)
    Costume.find(assignment.costume_id)
  end
end
