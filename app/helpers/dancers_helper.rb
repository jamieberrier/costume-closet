module DancersHelper
  def find_dancer
    @dancer = Dancer.find(params[:id])
  end

  def render_new_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/new'
  end

  def render_registration_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'registrations/new'
  end

  def render_edit_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/edit'
  end

  # Owner & Dancer: params[:id] -> dancer id
  # dancers -- show edit update destroy dancer_assignments current_assignments
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path(message: "Only the dancer's studio can access") unless current_user.dancers.include?(find_dancer)
    else # check if dancer is current user
      redirect_to root_path(message: 'Denied access') unless current_user.id == params[:id].to_i
    end
  end
end
