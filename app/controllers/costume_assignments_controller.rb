class CostumeAssignmentsController < ApplicationController
  before_action :require_logged_in!
  before_action :owner?, only: %i[index costume_assignments]

  # owner viewing all of its dance studio's costume assignments
  def index
    @costume_assignments = current_user.costume_assignments.order(dance_season: :desc)
  end

  # owner viewing a costume's assignments -- params[:costume_id]
  def costume_assignments
    find_costume
    @costume_assignments = CostumeAssignment.where(costume_id: @costume)
  end

  # dancer viewing all of his/her costume assignments / owner viewing a dancer's costume assignments -- params[:id]
  def dancer_assignments
    find_dancer
    @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(:dance_season, :genre, :song_name)
  end
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
