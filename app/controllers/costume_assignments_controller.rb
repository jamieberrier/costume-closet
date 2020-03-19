class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!

  def new
    @assignment = CostumeAssignment.new
  end

  def create
    @assignment = CostumeAssignment.new(assignment_params)
    flash.now[:danger] = "Creation failure: #{@assignment.errors.full_messages.to_sentence}"
    render 'costume_assignments/new' unless @assignment.save
  end

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
    find_assignment
  end

  def current_assignments
    if dancer?
      @assignments = CostumeAssignment.current_costumes(current_user)
    else
      @assignments = CostumeAssignment.current_studio_costumes(current_user)
      # can I deal wiht this in view instead?
      @costumes = Costume.find_by_assignment(@assignments)
    end
  end

  private

  def assignment_params
    params.require(:costume_assignment).permit(:dancer_id, :costume_id, :costume_condition, :costume_size, :song_name, :genre, :dance_season, :shoe, :tight)
  end

  def find_assignment
    @costume_assignment = CostumeAssignment.find(params[:id])
  end
end
