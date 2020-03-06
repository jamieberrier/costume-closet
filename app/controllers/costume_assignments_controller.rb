class CostumeAssignmentsController < ApplicationController
  def index
    if params.include?(:dancer_id)
      @dancer = Dancer.find(params[:dancer_id])
      @costume_assignments = CostumeAssignment.where(dancer_id: @dancer.id).order(:dance_season, :genre, :song_name)
    else
      @costume_assignments = CostumeAssignment.all.order(:dance_season, :genre, :song_name)
    end
  end
end
