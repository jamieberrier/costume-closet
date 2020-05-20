class CostumeAssignmentsController < ApplicationController
  before_action :require_dance_studio_owner, only: :index
  before_action :require_studio_costume, only: %i[costume_assignments season_assignments delete_season_assignments]
  before_action :set_costume, only: %i[costume_assignments season_assignments]
  before_action :set_season_costume_assignments, only: %i[season_assignments delete_season_assignments]
  before_action :set_shared_info, only: %i[season_assignments]

  # nested --> params[:dance_studio_id]
  # url: /dance_studios/1/costume_assignments
  # owner viewing all of its dance studio's costume assignments
  def index
    @assignments = current_user.costume_assignments.order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # Studio viewing all of a costume's assignments
  # url: /costumes/3/assignments
  def costume_assignments
    @assignments = @costume.costume_assignments
  end

  # Studio viewing a costume's assignments for a season
  # params[:season]
  # url: /costumes/1/season_assignments?season=2020
  def season_assignments; end

  # Deletes a costume's assignments for a season
  # params[:season], params[:id] -> costume id
  def delete_season_assignments
    @assignments.destroy_all

    redirect_to costume_path(params[:id]), success: 'Assignments Deleted'
  end
end
