class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!

  def index
    if owner?
      if params[:costume_id] # owner viewing a costume's assignments
        @costume = Costume.find(params[:id])
        @costume_assignments = CostumeAssignment.where(costume_id: @costume)
      elsif params[:id] # owner viewing a dancer's costume assignments
        @dancer = Dancer.find(params[:id])
        @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
      else # owner viewing its dance studio's costume assignments
        @costume_assignments = current_user.costume_assignments.order(dance_season: :desc)
      end
    else # dancer viewing his/her costume assignments
      @dancer = Dancer.find(params[:id])
      @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
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
      # can I deal wiht this in view instead?
      @costumes = Costume.find_by_assignment(@costume_assignments)
    end
  end
end
