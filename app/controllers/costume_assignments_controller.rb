class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!

  def index
    if current_user.class.name == 'Dancer'
      @costume_assignments = CostumeAssignment.where(dancer_id: current_user.id).order(:dance_season, :genre, :song_name)
    elsif request.env['HTTP_REFERER'].include?('dancers')
      @dancer = Dancer.find(params[:dancer_id])
      @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
    else
      @costume_assignments = CostumeAssignment.all.order(:dance_season, :genre, :song_name)
    end
  end
end
