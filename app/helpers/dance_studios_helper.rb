module DanceStudiosHelper
  def find_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end

  # Owner
  # unnested, params[:id] -> dance studio id
  # dance_studios -- show edit update destroy current_assignments current_costumes unassigned_costumes
  def require_studio_ownership
    redirect_to root_path unless owner? && current_user.id == params[:id].to_i
  end
end
