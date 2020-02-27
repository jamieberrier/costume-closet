class DancersController < ApplicationController
  before_action :require_logged_in!, :dancer?, only: [:show]

  def create
    @dancer = Dancer.new(dancer_params)
    redirect_if_signup_failure(@dancer)
    log_in(@dancer, 'Successfully Registered!')
  end

  def show

  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
