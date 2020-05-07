module RegistrationsHelper
  def signing_up_as_dance_studio?
    params[:user_type] == 'dance_studio'
  end

  def signing_up_as_dancer?
    params[:user_type] == 'dancer'
  end

  def create_empty_user
    if signing_up_as_dance_studio?
      @dance_studio = DanceStudio.new
    else
      @dancer = Dancer.new
    end
  end

  def render_registration_form(new_user)
    flash.now[:danger] = "Signup failure: #{new_user.errors.full_messages.to_sentence}"

    render 'registrations/new'
  end
end
