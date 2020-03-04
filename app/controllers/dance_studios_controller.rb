class DanceStudiosController < ApplicationController
  before_action :require_logged_in!, :redirect_if_not_owner!, only: [:show]

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    try_to_save(@dance_studio)
    log_in(@dance_studio, 'Successfully Registered!')
  end

  def show

  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
