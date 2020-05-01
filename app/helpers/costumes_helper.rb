module CostumesHelper
  def find_costume
    @costume = Costume.find(params[:id])
  end

  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  # Owner
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign costume_assignments season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  def require_studio_costume
    redirect_to root_path(message: 'Only costume owner can access') unless owner? && current_user.costumes.include?(find_costume)
  end

  # Owner & Dancer: params[:id] -> costume id
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(find_costume)
  end
end
