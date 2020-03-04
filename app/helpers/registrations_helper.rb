module RegistrationsHelper
  def create_empty_user
    if request.env['REQUEST_PATH'].include?('dance_studio')
      @dance_studio = DanceStudio.new
    else
      @dancer = Dancer.new
    end
  end

  def signing_up_as_dance_studio?
    !!params[:dance_studio]
  end

  def signing_up_as_dancer?
    !!params[:dancer]
  end

  def try_to_save(user)
    @user = user
    flash.now[:danger] = "Signup failure: #{@user.errors.full_messages.to_sentence}"
    render 'registrations/new' unless @user.save
  end
end
