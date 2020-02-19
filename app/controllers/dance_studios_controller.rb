class DanceStudiosController < ApplicationController
  before_action :require_logged_in, only: [:show]
  
  def new
    @dance_studio = DanceStudio.new
  end

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    return redirect_to new_dance_studio_path unless @dance_studio.save

    session[:user_id] = @dance_studio.id

    redirect_to dance_studio_path(@dance_studio.id)
  end

  def show
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:email, :password, :studio_name, :owner_name)
  end
end
