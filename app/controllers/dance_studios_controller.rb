class DanceStudiosController < ApplicationController
  before_action :require_logged_in, only: [:show]
  
  def new
    if logged_in?
      redirect_to dance_studio_path(current_user), info: "Logged In"
    else
      @dance_studio = DanceStudio.new
    end
  end

  def googleAuth
    @dance_studio = DanceStudio.new(session[:dance_studio])
  end

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    return redirect_to new_dance_studio_path, danger: "Signup failure: #{@dance_studio.errors.full_messages.to_sentence}" unless @dance_studio.save
  
    log_in(@dance_studio, 'Successfully Registered!')
    #session[:user_id] = @dance_studio.id

    #redirect_to dance_studio_path(@dance_studio.id), success: 'Successfully Registered!'
  end

  def show
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
