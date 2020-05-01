class CostumeAssignmentsController < ApplicationController
  before_action :require_belongs_to_studio, only: :costume_assignments
  before_action :require_dance_studio_owner, only: :index
  before_action :require_studio_dancer, only: :dancer_assignments

  # nested --> params[:dance_studio_id]
  # url: /dance_studios/1/costume_assignments
  # owner viewing all of its dance studio's costume assignments
  def index
    @costume_assignments = current_user.costume_assignments.order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # TODO: should this be in costumes controller?
  # unnested
  # costume id --> params[:id]
  # url: /costumes/3/assignments
  # owner viewing all of a costume's assignments
  def costume_assignments
    find_costume
    @costume_assignments = CostumeAssignment.where(costume_id: @costume)
  end

  # TODO: should this be in dancers controller?
  # unnested
  # dancer id --> params[:id]
  # url: /dancers/3/costume_assignments
  # dancer viewing all costume assignments / owner viewing a dancer's costume assignments
  def dancer_assignments
    find_dancer
    @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(dance_season: :desc, genre: :asc, song_name: :asc)
  end
end
