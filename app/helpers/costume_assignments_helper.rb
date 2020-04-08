module CostumeAssignmentsHelper
  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end
end
