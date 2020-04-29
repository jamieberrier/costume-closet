module CostumesHelper
  def find_costume
    @costume = Costume.find(params[:id])
  end

  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  def redirect_if_not_assigned!
    redirect_to root_path unless current_user.costumes.include?(params[:id])
  end

  def redirect_if_not_studio!
    redirect_to root_path unless current_user.id == params[:dance_studio_id].to_i
  end
end
