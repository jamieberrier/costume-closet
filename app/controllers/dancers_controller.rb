class DancersController < ApplicationController
  before_action :require_logged_in!, only: [:show]
  before_action :is_dancer?
  
  def new
    if logged_in?
      redirect_to dance_studio_dancer_path(current_user.dance_studio_id, current_user), info: "You are logged In"
    else
      @dancer = Dancer.new
    end
  end

  def googleAuth
    @dancer = Dancer.new(session[:dancer])
  end

  def create
    @dancer = Dancer.new(dancer_params)

    return redirect_to new_dancer_path, danger: "Signup failure: #{@dancer.errors.full_messages.to_sentence}" unless @dancer.save
    
    log_in(@dancer, 'Successfully Registered!')
  end

  def show

  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
