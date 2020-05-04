module DanceStudiosHelper
  def find_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end

  def redirect_to_dance_studio_page(message)
    redirect_to dance_studio_path(current_user), success: message
  end

  def render_edit_studio_form
    flash.now[:danger] = "Edit failure: #{@dance_studio.errors.full_messages.to_sentence}"

    render 'dance_studios/edit'
  end

  # Owner
  # unnested, params[:id] -> dance studio id
  # dance_studios -- show edit update destroy current_assignments current_costumes unassigned_costumes
  def require_studio_ownership
    redirect_to root_path(message: 'Only dance studio owner can access') unless owner? && current_user.id == params[:id].to_i
  end
end
