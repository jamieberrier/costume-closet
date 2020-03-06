class DancersController < ApplicationController
  before_action :require_logged_in!
  before_action :dancer?, only: [:show]

  def create
    @dancer = Dancer.new(dancer_params)
    try_to_save(@dancer)
    log_in(@dancer, 'Successfully Registered!')
  end

  def show

  end

  def edit
    @dancer = Dancer.find(params[:id])
  end

  def index 

  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
