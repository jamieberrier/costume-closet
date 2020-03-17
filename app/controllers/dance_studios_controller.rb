class DanceStudiosController < ApplicationController
  before_action :redirect_if_not_owner!, except: :create
  skip_before_action :require_logged_in!, only: :create

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    try_to_save(@dance_studio)
    log_in(@dance_studio, 'Successfully Registered!')
  end

  def show

  end

  def edit
    @dance_studio = DanceStudio.find(params[:id])
  end

  def update
    @dance_studio = DanceStudio.find(params[:id])
    @dance_studio.update(dance_studio_params)
    redirect_to dance_studio_path(@dance_studio), success: 'Account Info Updated!'
  end

  def destroy
    @dance_studio = DanceStudio.find(params[:id])
    @dance_studio.destroy
    session.destroy
    redirect_to root_path, success: 'Account Deleted!'
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
