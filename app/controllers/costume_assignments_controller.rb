class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!
  # break out into other controllers?
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

  # assign costume actions...new?
  def assign_costume

  end
  # create?
  def assign

  end
  
=begin
  def new
    @assignment = CostumeAssignment.new
  end

  def create
    @assignment = CostumeAssignment.new(assignment_params)

    flash.now[:danger] = "Creation failure: #{@assignment.errors.full_messages.to_sentence}"
    render 'costume_assignments/new' unless @assignment.save

    redirect_to costume_assignment_path(@assignment)
  end
  # am I using this?
  def show
    binding.pry
    find_assignment
  end

  private

  def assignment_params
    params.require(:costume_assignment).permit(:dancer_id, :costume_id, :costume_condition, :costume_size, :song_name, :genre, :dance_season, :shoe, :tight)
  end
=end
end
