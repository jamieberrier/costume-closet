class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!

  def index
    if current_user.class.name == 'Dancer'
      @costume_assignments = CostumeAssignment.where(dancer_id: current_user.id).order(:dance_season, :genre, :song_name)
    elsif request.env['HTTP_REFERER'].include?('dancers')
      @dancer = Dancer.find(params[:id])
      @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
    elsif params[:costume_id]
      @costume_assignments = CostumeAssignment.where(costume_id: params[:costume_id])
    else
      @costume_assignments = CostumeAssignment.all.order(:dance_season, :genre, :song_name)
    end
  end

  def show
    @costume_assignment = CostumeAssignment.find_by(id: params[:id])
  end

  def current_assignments
    if dancer?
      @costume_assignments = CostumeAssignment.current_costumes(current_user)
    else
      @costume_assignments = CostumeAssignment.current_studio_costumes(current_user)
    end
  end
end
