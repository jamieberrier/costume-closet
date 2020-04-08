class DancersController < ApplicationController
  skip_before_action :require_logged_in!, only: :create

  def create
    @dancer = Dancer.new(dancer_params)
    try_to_save(@dancer)
    log_in(@dancer, 'Successfully Registered!')
  end

  def show
    find_dancer
  end

  def edit
    find_dancer
  end

  def update
    find_dancer
    @dancer.update(dancer_params)
    redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
  end

  def index 

  end

  def destroy
    find_dancer
    # set current_dancer to false & password/confirmation to "..."
    @dancer.update(current_dancer: false, password: "...", password_confirmation: "...")
    # destroy session
    session.destroy
    # redirect to home page
    redirect_to root_path, success: 'Account Deactivated!'
  end
  # Current costume assignments
  def current_assignments
    @assignments = Dancer.current_costumes(current_user)
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
