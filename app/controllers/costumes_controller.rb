class CostumesController < ApplicationController
  before_action :require_dance_studio_owner, only: %i[new create index]
  before_action :require_costume_ownership, only: %i[show]
  before_action :require_studio_costume, except: %i[new create index show]
  before_action :set_costume, except: %i[new create index delete_season_assignments]
  before_action :set_season_costume_assignments, only: %i[season_assignments edit_season_assignments delete_season_assignments assign_costume]

  # url: /dance_studios/1/costumes
  def index
    @costumes = current_user.costumes
  end

  # Studio & Dancer can view
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

  # url: /costumes/3/edit
  def edit; end

  def create
    # params[:costume] -> {"dance_studio_id"=>"1", top_description"=>"", "bottoms_description"=>"", "onepiece_description"=>"nvkdsn;kbv", "hair_accessory"=>"none", "picture"=>"", "costume_assignments_attributes"=>{"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}}} permitted: false>
    # params[:costume][:costume_assignments_attributes] -> {"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}} permitted: false>
    @costume = Costume.new(costume_params)
    # get shared assignment info to check if assigning costume/assignment errors
    fetch_shared_assignment_info
    # redirect to new costume form if costume validation error(s)
    return redirect_to_new_costume_form(danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}") unless @costume.save
    # check if all shared assignment info fields empty
    return redirect_to_costume_path('Costume Successfully Created!') if @assignment_info.values.all?('')

    # check if the dance_season or song_name value is empty
    redirect_if_required_fields_empty and return

    return redirect_to_new_costume_form(danger: 'dancer info failure') if @costume.costume_assignments.empty?

    redirect_to_costume_path('Costume Successfully Created & Assigned!')
  end

  def update
    return render :edit unless update_costume

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
    # get shared assignment info
    fetch_shared_assignment_info
    # check if the dance_season or song_name value is empty
    redirect_if_required_fields_empty and return
    # try to persist to db
    @updated = update_costume
    # check that if updates, @costume.costume_assignments.count is now greater than count
    redirect_if_updated_with_same_assignment_count and return
    # redirect if updated correctly
    redirect_if_updated and return
    # redirect if costume assignments are invalid
    redirect_to assign_costume_path(@costume), danger: "Assignment failure: #{@costume.errors.full_messages.to_sentence}"
  end

  # Studio viewing all of a costume's assignments
  # url: /costumes/3/assignments
  def costume_assignments
    @assignments = @costume.costume_assignments
  end

  # Studio viewing a costume's assignments for a season
  # params[:season]
  # url: /costumes/1/season_assignments?season=2020
  def season_assignments; end

  # Displays form for studio to edit a costume's assignments for a season
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

  # params[:season], params[:id] -> costume id
  def delete_season_assignments
    @assignments.destroy_all

    redirect_to costume_path(params[:id]), success: 'Assignments Deleted'
  end

  private

  # Studio & Dancer: params[:id] -> costume id
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(set_costume)
  end

  # Studio
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign costume_assignments season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  def require_studio_costume
    redirect_to root_path(message: 'Only costume owner can access') unless owner? && current_user.costumes.include?(set_costume)
  end

  def set_costume
    @costume = Costume.find(params[:id])
  end

  def set_season_costume_assignments
    @season = params[:season]
    @assignments = CostumeAssignment.season_assignments(params)
  end

  # instanstiates an empty instance of costume assignment - to collect the shared data for the assignments
  def build_shared_assignment_info
    @assignment_info = @costume.costume_assignments.build
  end

  # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
  def build_assignments_with_dancer_id
    current_user.dancers.current_dancers.each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id)
    end
  end

  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  # build a costume_assignments record unless one with dancer's id already exists
  def build_assignments_unless_exists
    current_user.dancers.current_dancers.each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id) unless @assignments.exists?(dancer_id: dancer.id)
    end
  end

  def update_costume
    @costume.update(costume_params)
  end

  ## create action helpers
  def redirect_to_new_costume_form(message)
    redirect_to new_dance_studio_costume_path(current_user.id), message
  end

  ## create & assign action helpers
  # gets shared assignment info
  def fetch_shared_assignment_info
    @assignment_info = params[:costume][:costume_assignments_attributes].permit!.to_h.first.pop
    # => {"dance_season"=>"", "song_name"=>"", "genre"=>"", "hair_accessory"=>"", "shoe"=>"", "tight"=>""}
    @dance_season_empty = @assignment_info[:dance_season].empty?
    @song_name_empty = @assignment_info[:song_name].empty?
    @count = @costume.costume_assignments.count # gets no. of assignments before updating
  end

  # checks if the dance_season or song_name value is empty
  def redirect_if_required_fields_empty
    if params[:action] == 'create'
      redirect_to new_dance_studio_costume_path(current_user.id), danger: 'Creation failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    else
      redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    end
  end

  ## assign action helpers
  # check that if updates, @costume.costume_assignments.count is now greater than count
  def redirect_if_updated_with_same_assignment_count
    redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must also select at least 1 dancer w/ costume size & costume condition' if @updated && @count == @costume.costume_assignments.count
  end

  # redirect if updated correctly
  def redirect_if_updated
    redirect_to season_assignments_path(@costume, season: @costume.costume_assignments.last.dance_season) if @updated
  end

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :dance_studio_id, :costume_assignments_attributes => [:id, :dancer_id, :song_name, :dance_season, :genre, :hair_accessory, :shoe, :tight, :costume_size, :costume_condition])
  end
end
