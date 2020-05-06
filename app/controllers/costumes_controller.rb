class CostumesController < ApplicationController
  before_action :require_dance_studio_owner, only: %i[new create index]
  before_action :require_costume_ownership, only: %i[show]
  before_action :require_studio_costume, except: %i[new create index show]
  before_action :find_costume, except: %i[new create index delete_season_assignments]
  before_action :find_season_costume_assignments, only: %i[season_assignments edit_season_assignments assign_costume]

  # Dance Studio & Dancer can view
  # url: /costumes/3
  def show; end

  # url: /dance_studios/1/costumes/new
  def new
    @costume = Costume.new(dance_studio_id: params[:dance_studio_id])
    # instanstiates an empty instance of costume assignment - to collect the shared data for the assignments
    build_shared_assignment_info
    # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
    build_assignments_with_dancer_id
  end

  def create
    # params[:costume] -> {"dance_studio_id"=>"1", top_description"=>"", "bottoms_description"=>"", "onepiece_description"=>"nvkdsn;kbv", "hair_accessory"=>"none", "picture"=>"", "costume_assignments_attributes"=>{"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}}} permitted: false>
    # params[:costume][:costume_assignments_attributes] -> {"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}} permitted: false>
    @costume = Costume.new(costume_params)

    return redirect_to new_dance_studio_costume_path(current_user.id), danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}" unless @costume.save

    if @costume.costume_assignments.empty?
      redirect_to_costume_path('Costume Successfully Created!')
    else
      redirect_to_costume_path('Costume Successfully Created & Assigned!')
    end
  end

  # url: /dance_studios/1/costumes
  def index
    @costumes = current_user.costumes
  end

  # url: /costumes/3/edit
  def edit; end

  def update
    return redirect_to edit_costume_path(@costume, dance_studio: current_user), danger: "Edit failure: #{@costume.errors.full_messages.to_sentence}" unless update_costume

    redirect_to_costume_path('Costume Updated!')
  end

  def destroy
    @costume.destroy

    redirect_to dance_studio_costumes_path(current_user), success: 'Costume Deleted'
  end

  # Displays form to assign a costume
  # url: /costumes/5/assign
  def assign_costume
    build_shared_assignment_info
    build_assignments_with_dancer_id
  end

  # Receives data from costume assignment form
  def assign
    # gets shared assignment info
    assignment_info = params[:costume][:costume_assignments_attributes].permit!.to_h.first.pop
    # => {"dance_season"=>"", "song_name"=>"", "genre"=>"", "hair_accessory"=>"", "shoe"=>"", "tight"=>""}

    # checks if the dance_season or song_name value is empty
    return redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if assignment_info[:dance_season].empty? || assignment_info[:song_name].empty?

    count = @costume.costume_assignments.count # gets no. of assignments before updating
    updated = update_costume # try to persist to db

    # check that if updates, @costume.costume_assignments.count is now greater than count
    return redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if updated && count == @costume.costume_assignments.count
    return redirect_to season_assignments_path(@costume, season: @costume.costume_assignments.last.dance_season) if updated

    redirect_to assign_costume_path(@costume), danger: "Assignment failure: #{@costume.errors.full_messages.to_sentence}"
  end

  # owner viewing all of a costume's assignments
  # url: /costumes/3/assignments
  def costume_assignments
    @assignments = CostumeAssignment.where(costume_id: @costume)
  end

  # owner viewing a costume's assignments for a season
  # params[:season]
  # url: /costumes/1/season_assignments?season=2020
  def season_assignments; end

  # Displays form for owner to edit a costume's assignments for a season
  # params[:season]
  # url: /costumes/1/edit_season_assignments?season=2020
  def edit_season_assignments
    @assignment_info = @costume.costume_assignments.build(hair_accessory: @assignments.first.hair_accessory, tight: @assignments.first.tight, shoe: @assignments.first.shoe, genre: @assignments.first.genre, song_name: @assignments.first.song_name, costume_id: @costume.id, dance_season: @season, id: nil, dancer_id: nil, costume_size: nil, costume_condition: nil)

    build_assignments_unless_exists
  end

  def update_season_assignments
    update_costume

    redirect_to season_assignments_path(@costume, season: params[:costume][:costume_assignments_attributes].values[0].values[0])
  end

  # TODO: better in costume assignments controller?
  # params[:season], params[:id] -> costume id
  def delete_season_assignments
    CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", params[:id], params[:season]).destroy_all

    redirect_to costume_path(params[:id]), success: 'Assignments Deleted'
  end

  private

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :dance_studio_id, :costume_assignments_attributes => [:id, :dancer_id, :song_name, :dance_season, :genre, :hair_accessory, :shoe, :tight, :costume_size, :costume_condition])
  end
end
