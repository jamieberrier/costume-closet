class CostumeAssignmentsController < ApplicationController
  before_action :require_dance_studio_owner, only: :index
  before_action :require_studio_costume, only: %i[costume_assignments season_assignments delete_season_assignments]
  before_action :set_costume, only: %i[costume_assignments season_assignments]
  before_action :set_season_costume_assignments, only: %i[season_assignments delete_season_assignments]
  before_action :set_shared_info, only: %i[season_assignments]

  # Displays all of a dance studio's costume assignments
  # nested --> params[:dance_studio_id]
  # GET /dance_studios/:dance_studio_id/costume_assignments
  def index
    @assignments = current_user.costume_assignments.order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # Displays all of a costume's assignments
  # GET /costumes/:id/assignments
  def costume_assignments
    @assignments = @costume.costume_assignments
  end

  # Displays a costume's assignments for a season
  # params[:season]
  # GET /costumes/:id/season_assignments
  def season_assignments; end

  # Deletes a costume's assignments for a season
  # params[:season]
  # DELETE /costumes/:id/season_assignments
  def delete_season_assignments
    @assignments.destroy_all

    redirect_to costume_path(params[:id]), success: 'Assignments Deleted'
  end
end
