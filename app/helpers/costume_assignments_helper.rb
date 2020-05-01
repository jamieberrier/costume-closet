module CostumeAssignmentsHelper
  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end

  def unassigned?
    # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  # Owner & Dancer: costume id -> params[:id]
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path unless current_user.costumes.include?(find_costume)
  end

  # Owner & Dancer: params[:id] -> dancer id
  # dancers -- show edit update destroy current_assignments
  # costume_assignments -- dancer_assignments
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path unless current_user.dancers.include?(find_dancer)
    else # check if dancer is current user
      redirect_to root_path unless current_user.id == params[:id].to_i
    end
  end

  # Owner
  # unnested, params[:id] -> dance studio id
  # dance_studios -- show edit update destroy current_assignments current_costumes unassigned_costumes
  def require_studio_ownership
    redirect_to root_path unless owner? && current_user.id == params[:id].to_i
  end

  # Owner
  # nested, params[:dance_studio_id] -> dance studio id
  # dancers -- new index current dancers
  # costumes -- new create index
  # costume assignments -- index
  def require_dance_studio_owner
    redirect_to root_path unless owner? && current_user.id == params[:dance_studio_id].to_i
  end

  # Owner
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign_season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  # costume_asignments -- costume_assignments
  def require_belongs_to_studio
    redirect_to root_path unless owner? && current_user.costumes.include?(find_costume)
  end
end
