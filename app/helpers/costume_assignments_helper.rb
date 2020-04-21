module CostumeAssignmentsHelper
  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end

  def unassigned?
    # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
    current_user.unassigned_studio_costumes.include?(@costume)
  end
end
