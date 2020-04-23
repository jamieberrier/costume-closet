class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!
  before_action :owner?, only: %i[index costume_assignments]

  # owner viewing all of its dance studio's costume assignments
  def index
    @costume_assignments = current_user.costume_assignments.order(dance_season: :desc)
  end

  # TODO: should this be in costumes controller?
  # owner viewing a costume's assignments
  # params[:costume_id]
  def costume_assignments
    find_costume
    @costume_assignments = CostumeAssignment.where(costume_id: @costume)
  end

  # owner viewing a costume's assignments for a season
  # params[:season]
  def season_assignments
    find_costume
    @costume_assignments = CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", @costume.id, params[:season])
  end

  # TODO: should this be in dancers controller?
  # dancer viewing all of his/her costume assignments / owner viewing a dancer's costume assignments -- params[:id]
  def dancer_assignments
    find_dancer
    @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
  end
end
