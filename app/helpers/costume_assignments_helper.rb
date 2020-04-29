module CostumeAssignmentsHelper
  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end

  def unassigned?
    # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  # Owner & Dancer: costume id -> params[:id]
  # costumes -- except: new create index
  def redirect_if_not_assigned!
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path unless current_user.costumes.include?(find_costume)
  end

  # Owner & Dancer: dancer id -> params[:id]
  # dancers -- only: show edit destroy current_assignments
  # costume_assignments -- only: :dancer_assignments
  def redirect_if_not_studio_dancer!
    if owner? # check if dancer belongs to studio
      redirect_to root_path unless current_user.dancers.include?(find_dancer)
    else # check if dancer is current user
      redirect_to root_path unless current_user.id == params[:id].to_i
    end
  end

  # Owner
  # unnested, dance studio id -> params[:id]
  # dance_studios -- except: create
  def redirect_if_not_dance_studio_owner!
    redirect_to root_path unless owner? && current_user.id == params[:id].to_i
  end

  # Owner
  # nested, dance studio id -> params[:dance_studio_id]
  # dancers -- only: new index current dancers
  # costumes -- only: new create index
  def redirect_if_not_studio_owner!
    redirect_to root_path unless owner? && current_user.id == params[:dance_studio_id].to_i
  end

  # Owner
  # no dance studio id
  # costume_asignments -- only: costume_assignments
  def redirect_if_not_owner_assigned!
    redirect_to root_path unless owner? && current_user.costumes.include?(find_costume)
  end
end
