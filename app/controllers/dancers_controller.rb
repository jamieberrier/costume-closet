class DancersController < ApplicationController
  skip_before_action :require_logged_in!, only: :create
  before_action :redirect_if_not_studio_owner!, only: %i[new index current_dancers]
  before_action :redirect_if_not_studio_dancer!, only: %i[show edit destroy current_assignments]

  # For Dance Studio to create a new dancer
  def new
    @dancer = Dancer.new(dance_studio_id: current_user.id, password: 'password', password_confirmation: 'password')
  end

  def create
    @dancer = Dancer.new(dancer_params)

    if @dancer.save && owner?
      redirect_to dance_studio_path(current_user), success: 'Dancer Added!'
    elsif @dancer.save
      log_in(@dancer, 'Successfully Registered!')
    elsif owner?
      render_new_form
    else
      render_registration_form
    end
  end

  # Uses instance variable b/c dance_studio can also view
  def show
    find_dancer
  end

  # Uses instance variable b/c dance_studio can also edit
  def edit
    find_dancer
  end

  def update
    find_dancer
    if @dancer.update(dancer_params)
      redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
    else
      render_edit_form
    end
  end

  # Only dance_studio can view
  def index
    # all dancers at a dance_studio
  end

  def destroy
    find_dancer
    # set current_dancer to false & password/confirmation to "..."
    @dancer.update(current_dancer: false, password: "...", password_confirmation: "...")

    if dancer?
      # reset session
      reset_session
      # redirect to home page
      redirect_to root_path, success: 'Account Deactivated!'
    else # if studio owner deactivating a dancer account
      # redirect to studio page
      redirect_to dance_studio_path(current_user), success: 'Account Deactivated'
    end
  end

  # Displays dancer's current costume assignments with costume picture
  def current_assignments
    find_dancer
    @assignments = CostumeAssignment.current_dancer_costumes(@dancer)
  end

  # Displays the current dancers for a dance studio
  def current_dancers
    @dancers = Dancer.current_dancers(current_user)
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
