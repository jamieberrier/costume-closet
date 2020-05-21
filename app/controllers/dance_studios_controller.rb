class DanceStudiosController < ApplicationController
  skip_before_action :require_logged_in, only: :create
  before_action :require_studio_ownership, except: :create
  before_action :set_dance_studio, only: %i[show edit update destroy]

  # url: /dance_studios/:id
  def show; end

  # url: /dance_studios/:id/edit
  def edit; end

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    return render_registration_form unless @dance_studio.save

    log_in(@dance_studio, 'Successfully Registered!')
  end

  def update
    return render :edit unless @dance_studio.update(dance_studio_params)

    redirect_to dance_studio_path(@dance_studio), success: 'Account Info Updated!'
  end

  def destroy
    @dance_studio.destroy
    logout('Account Deleted!')
  end

  # Displays current costume assignments for a dance studio
  # url: /dance_studios/:id/current_assignments
  def current_assignments
    @assignments = current_user.current_studio_assignments
    @costumes = @assignments.find_costumes
    @season = @assignments.first.dance_season unless @assignments.empty?
  end

  # Displays the current season costumes for a dance studio
  # url: /dance_studios/:id/current_costumes
  def current_costumes
    @costumes = current_user.current_studio_costumes
    @season = Time.now.year
  end

  # Displays the current season's unassigned costumes for a dance studio
  # url: /dance_studios/:id/unassigned_costumes
  def unassigned_costumes
    @costumes = current_user.unassigned_studio_costumes
  end

  # Displays the dance studio's costumes that contain the search term in their description
  def search
    @costumes = current_user.search(params[:search])
  end

  private

  def set_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
