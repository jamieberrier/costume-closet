module CostumeAssignmentsHelper
  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end

  def unassigned?
    # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  # Owner
  # nested, params[:dance_studio_id] -> dance studio id
  # dancers -- new index current dancers
  # costumes -- new create index
  # costume assignments -- index
  def require_dance_studio_owner
    redirect_to root_path(message: 'Only studio owner can access') unless owner? && current_user.id == params[:dance_studio_id].to_i
  end
end
