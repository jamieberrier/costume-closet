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
    @assignment_info = @costume.build_shared_assignment_info
    # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
    @costume.build_assignments_with_dancer_id(current_user)
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

    ## costume saved - check if assigning costume
    # check if not assigning costume - all shared assignment info fields empty
    redirect_to_costume_path_if_not_assigning and return
    ## assigning costume - validate assignment(s)
    # check if the dance_season or song_name value is empty
    redirect_to_form_if_required_fields_empty and return
    # check if dancer info empty
    redirect_to_form_if_assignment_incomplete and return
    # valid assignment(s)
    redirect_to_costume_path('Costume Successfully Created & Assigned!')
  end

  def update
    return render :edit unless @costume.update(costume_params)

    redirect_to_costume_path('Costume Updated!')
  end

  def destroy
    @costume.destroy

    redirect_to dance_studio_costumes_path(current_user), success: 'Costume Deleted'
  end

  # Displays form to assign a costume
  # url: /costumes/5/assign
  def assign_costume
    @assignment_info = @costume.build_shared_assignment_info
    @costume.build_assignments_with_dancer_id(current_user)
  end

  # Receives data from costume assignment form
  def assign
    # get shared assignment info
    fetch_shared_assignment_info
    # check if the dance_season or song_name value is empty
    redirect_to_form_if_required_fields_empty and return
    # try to persist to db
    @updated = @costume.update(costume_params)
    # check that if updates, @costume.costume_assignments.count is now greater than count
    return redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must also select at least 1 dancer w/ costume size & costume condition' if @updated && @count == @costume.costume_assignments.count

    # redirect if updated correctly
    redirect_to_season_assignments_path_if_updated and return
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
    @assignment_info = @costume.shared_assignment_info(@assignments.first)

    @costume.build_assignments_unless_exists(current_user, @assignments)
  end

  # Receives info from edit_season_assignments form
  def update_season_assignments
    @costume.update(costume_params)

    redirect_to season_assignments_path(@costume, season: params[:costume][:costume_assignments_attributes].values[0].values[0])
  end

  # Deletes a costume's assignments for a season
  # params[:season], params[:id] -> costume id
  def delete_season_assignments
    @assignments.destroy_all

    redirect_to costume_path(params[:id]), success: 'Assignments Deleted'
  end

  private

  def set_costume
    @costume = Costume.find(params[:id])
  end

  def set_season_costume_assignments
    @season = params[:season]
    @assignments = CostumeAssignment.season_assignments(params)
  end

  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  ## create action helpers
  def redirect_to_new_costume_form(message)
    redirect_to new_dance_studio_costume_path(current_user.id), message
  end

  # check if all shared assignment info fields empty
  def redirect_to_costume_path_if_not_assigning
    redirect_to_costume_path('Costume Successfully Created!') if @assignment_info.values.all?('')
  end

  # check if dancer info empty
  def redirect_to_form_if_assignment_incomplete
    redirect_to_new_costume_form(danger: 'Must select at least 1 dancer w/ costume size & costume condition') if @costume.costume_assignments.empty?
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
  def redirect_to_form_if_required_fields_empty
    if params[:action] == 'create'
      redirect_to new_dance_studio_costume_path(current_user.id), danger: 'Creation failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    else
      redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    end
  end

  ## assign action helper
  # redirect if updated correctly
  def redirect_to_season_assignments_path_if_updated
    redirect_to season_assignments_path(@costume, season: @costume.costume_assignments.last.dance_season) if @updated
  end

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :dance_studio_id, :costume_assignments_attributes => [:id, :dancer_id, :song_name, :dance_season, :genre, :hair_accessory, :shoe, :tight, :costume_size, :costume_condition])
  end
end
