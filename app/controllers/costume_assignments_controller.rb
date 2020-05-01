class CostumeAssignmentsController < ApplicationController
  before_action :require_dance_studio_owner, only: :index

  # nested --> params[:dance_studio_id]
  # url: /dance_studios/1/costume_assignments
  # owner viewing all of its dance studio's costume assignments
  def index
    @costume_assignments = current_user.costume_assignments.order(dance_season: :desc, genre: :asc, song_name: :asc)
  end
end
