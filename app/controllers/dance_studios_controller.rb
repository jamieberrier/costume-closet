class DanceStudiosController < ApplicationController
  before_action :redirect_if_not_owner!, except: :create
  skip_before_action :require_logged_in!, only: :create

  def create
    @dance_studio = DanceStudio.new(dance_studio_params)

    if @dance_studio.save
      log_in(@dance_studio, 'Successfully Registered!')
    else
      flash.now[:danger] = "Signup failure: #{@dance_studio.errors.full_messages.to_sentence}"
      render 'registrations/new'
    end
  end

  def show

  end

  def edit
    find_dance_studio
  end

  def update
    find_dance_studio
    @dance_studio.update!(dance_studio_params)
    redirect_to dance_studio_path(@dance_studio), success: 'Account Info Updated!'
  end

  def destroy
    find_dance_studio
    @dance_studio.destroy
    session.destroy
    redirect_to root_path, success: 'Account Deleted!'
  end

  # current costume assignments for a dance studio
  def current_assignments
    @assignments = current_user.current_studio_assignments
    @costumes = Costume.find_by_assignment(@assignments)
    # get assignment info for costume
    @info = @assignments.first
  end

  # current costumes for a dance studio
  def current_costumes
    @costumes = current_user.current_studio_costumes
    @season = Time.now.year
  end

  # currently unassigned costumes for a dance studio
  def unassigned_costumes
    @costumes = current_user.unassigned_studio_costumes
  end

  private

  def dance_studio_params
    params.require(:dance_studio).permit(:studio_name, :owner_name, :email, :password, :password_confirmation)
  end
end
