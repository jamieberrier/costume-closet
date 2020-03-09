class DancersController < ApplicationController
  before_action :require_logged_in!, only: [:show, :edit, :update, :index]
  before_action :dancer?, only: [:show]

  def create
    @dancer = Dancer.new(dancer_params)
    try_to_save(@dancer)
    log_in(@dancer, 'Successfully Registered!')
  end

  def show
    
  end

  def edit
    @dance_studio = DanceStudio.find(params[:dance_studio_id])
    @dancer = Dancer.find(params[:id])
  end

  def update
    @dancer = Dancer.find(params[:id])
    @dancer.update(dancer_params)
    redirect_to dance_studio_dancer_path(@dancer.dance_studio_id, @dancer), success: 'Account Info Updated!'
  end

  def index 

  end

  def destroy
    @dancer = Dancer.find(params[:id])
    
    @dancer.update_attribute(:current_dancer, false)
    session.destroy
    redirect_to root_path, success: 'Account Deactivated!'
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
