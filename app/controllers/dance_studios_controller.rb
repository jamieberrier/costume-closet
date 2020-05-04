class DanceStudiosController < ApplicationController
  skip_before_action :require_logged_in, only: :create
  before_action :require_studio_ownership, except: :create

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    if @dance_studio.save
      log_in(@dance_studio, 'Successfully Registered!')
    else
      render_registration_form(@dance_studio)
    end
  end

  # url: /dance_studios/1
  def show

  end

  # url: /dance_studios/1/edit
  def edit
    find_dance_studio
  end

  def update
    find_dance_studio

    if @dance_studio.update(dance_studio_params)
      redirect_to dance_studio_path(@dance_studio), success: 'Account Info Updated!'
    else
      flash.now[:danger] = "Edit failure: #{@dance_studio.errors.full_messages.to_sentence}"

      render 'dance_studios/edit'
    end
  end

  def destroy
    find_dance_studio
    @dance_studio.destroy
    logout('Account Deleted!')
  end

  # current costume assignments for a dance studio
  # url: /dance_studios/1/current_assignments
  def current_assignments
    @assignments = current_user.current_studio_assignments
    @costumes = Costume.find_by_assignment(@assignments)
    @season = @assignments.first.dance_season unless @assignments.empty?
  end

  # current costumes for a dance studio
  # url: /dance_studios/1/current_costumes
  def current_costumes
    @costumes = current_user.current_studio_costumes
    @season = Time.now.year
  end

  # currently unassigned costumes for a dance studio
  # url: /dance_studios/1/unassigned_costumes
  def unassigned_costumes
    @costumes = current_user.unassigned_studio_costumes
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
