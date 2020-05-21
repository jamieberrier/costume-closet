class DanceStudiosController < ApplicationController
  skip_before_action :require_logged_in, only: :create
  before_action :require_studio_ownership, except: :create
  before_action :set_dance_studio, only: %i[show edit update destroy]

  # GET /dance_studios/:id
  def show; end

  # GET /dance_studios/:id/edit
  def edit; end

  # POST /dance_studios
  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    return render_registration_form unless @dance_studio.save

    log_in(@dance_studio, 'Successfully Registered!')
  end

  # PATCH/PUT /dance_studios/:id
  def update
    return render :edit unless @dance_studio.update(dance_studio_params)

    redirect_to_dance_studio_page('Account Info Updated!')
  end

  # DELETE /dance_studios/:id
  def destroy
    @dance_studio.destroy
    logout('Account Deleted!')
  end

  # Displays a dance studio's current costume assignments
  # GET /dance_studios/:id/current_assignments
  def current_assignments
    @assignments = current_user.current_studio_assignments
    @costumes = @assignments.find_costumes
    @season = @assignments.first.dance_season unless @assignments.empty?
  end

  # Displays a dance studio's current season costumes
  # GET /dance_studios/:id/current_costumes
  def current_costumes
    @costumes = current_user.current_studio_costumes
    @season = Time.now.year
  end

  # Displays a dance studio's unassigned costumes for the current season
  # GET /dance_studios/:id/unassigned_costumes
  def unassigned_costumes
    @costumes = current_user.unassigned_studio_costumes
  end

  # Displays a dance studio's costumes with the search term in their description
  # GET /dance_studios/:id/search
  def search
    @costumes = current_user.search(params[:search])
  end

  private

  # before_action except: :create
  def require_studio_ownership
    redirect_to root_path(message: 'Only dance studio owner can access') unless owner? && current_user.id == params[:id].to_i
  end

  # before_action only: %i[show edit update destroy]
  def set_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
