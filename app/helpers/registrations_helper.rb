module RegistrationsHelper
  def signing_up_as_dance_studio?
    params[:user_type] == 'dance_studio'
  end

  def signing_up_as_dancer?
    params[:user_type] == 'dancer'
  end

  def create_empty_user
    signing_up_as_dance_studio? ? @dance_studio = DanceStudio.new : @dancer = Dancer.new
  end

  def render_registration_form
    render 'registrations/new'
  end
end
