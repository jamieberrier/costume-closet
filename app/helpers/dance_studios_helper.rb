module DanceStudiosHelper
  def find_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end

  def redirect_if_not_dance_studio_owner!
    # unnested
    redirect_to root_path unless owner? && current_user.id == params[:id].to_i
  end
end
