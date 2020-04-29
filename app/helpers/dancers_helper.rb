module DancersHelper
  def redirect_if_not_studio_dancer!
    if owner?
      redirect_to root_path unless current_user.dancers.include?(params[:id])
    else
      redirect_to root_path unless current_user.id == params[:id].to_i
    end
  end

  def redirect_if_not_studio_owner!
    # nested
    # new index current dancers -> params[:dance_studio_id]
    redirect_to root_path unless owner? && current_user.id == params[:dance_studio_id].to_i
  end

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
end
