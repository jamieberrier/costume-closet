module DancersHelper
  # Studio & Dancer: params[:id] -> dancer id
  # dancers -- show edit update destroy dancer_assignments current_assignments
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path(message: "Only the dancer's studio can access") unless current_user.dancers.include?(find_dancer)
    else # check if dancer is current user
      redirect_to root_path(message: 'Denied access') unless current_user.id == params[:id].to_i
    end
  end

  def find_dancer
    @dancer = Dancer.find(params[:id])
  end

  def render_new_dancer_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/new'
  end

  ## create action helpers
  def redirect_studio_if_saved
    redirect_to_dance_studio_page('Dancer Added!') if @saved && owner?
  end

  def log_in_dancer_if_saved
    log_in(@dancer, 'Successfully Registered!') if @saved
  end

  def redirect_studio_if_error
    render_new_dancer_form if owner?
  end

  # Renders dancer edit form if error
  def render_edit_dancer_form
    flash.now[:danger] = "Edit failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/edit'
  end
end
