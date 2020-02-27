class RegistrationsController < ApplicationController
  def new
    redirect_if_logged_in!
    create_empty_user
  end

  def googleAuth
    if session[:dance_studio]
      @dance_studio = DanceStudio.new(session[:dance_studio])
    else 
      @dancer = Dancer.new(session[:dancer])
    end
  end
=begin
  def create
    if dance_studio_params
      @dance_studio = DanceStudio.new(dance_studio_params)
      redirect_if_signup_failure(@dance_studio)
      #return redirect_to new_dance_studio_path, danger: "Signup failure: #{@dance_studio.errors.full_messages.to_sentence}" unless @dance_studio.save
      log_in(@dance_studio, 'Successfully Registered!')
    else
      @dancer = Dancer.new(dancer_params)
      redirect_if_signup_failure(@dancer)
      #return redirect_to new_dancer_path, danger: "Signup failure: #{@dancer.errors.full_messages.to_sentence}" unless @dancer.save
      log_in(@dancer, 'Successfully Registered!')
    end
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
=end
end
