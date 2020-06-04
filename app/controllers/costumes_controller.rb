class CostumesController < ApplicationController
  before_action :require_dance_studio_owner, only: %i[new create index]
  before_action :require_costume_ownership, only: %i[show]
  before_action :require_studio_costume, except: %i[new create index show]
  before_action :set_costume, except: %i[new create index]
  before_action :set_season_costume_assignments, only: %i[assign_costume edit_season_assignments]
  before_action :set_shared_info, only: %i[edit_season_assignments]
  before_action :fetch_shared_assignment_info, only: %i[create assign]

  # Studio
  # Displays all of a dance studio's costumes pictures/descriptions
  # GET /dance_studios/:dance_studio_id/costumes
  def index
    @costumes = current_user.costumes
  end

  # Studio & Dancer
  # Displays an individual costume info
  # GET /costumes/:id
  def show; end

  # Studio
  # Displays form for a dance studio to create a new costume
  # GET /dance_studios/:dance_studio_id/costumes/new
  def new
    @costume = Costume.new(dance_studio_id: params[:dance_studio_id])
    # instanstiates an empty instance of costume assignment - to collect the shared data for the assignments
    @assignment_info = @costume.build_shared_assignment_info
    # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
    @costume.build_assignments_with_dancer_id(current_user)
  end

  # Studio
  # Displays form for a dance studio to edit a costume's info
  # GET /costumes/:id/edit
  def edit; end

  # Studio
  # Receives data from new form
  # POST /dance_studios/:dance_studio_id/costumes
  def create
    # params[:costume] -> {"dance_studio_id"=>"1", top_description"=>"", "bottoms_description"=>"", "onepiece_description"=>"nvkdsn;kbv", "hair_accessory"=>"none", "picture"=>"", "costume_assignments_attributes"=>{"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}}} permitted: false>
    # params[:costume][:costume_assignments_attributes] -> {"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}} permitted: false>
    @costume = Costume.new(costume_params)
    # redirect to new costume form if costume validation error(s)
    return redirect_to_new_costume_form(danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}") unless @costume.save

    ## costume saved - check if assigning costume
    # check if not assigning costume - all shared assignment info fields empty
    redirect_to_costume_path_if_not_assigning and return
    ## assigning costume - validate assignment(s)
    # check if the dance_season or song_name value is empty
    redirect_to_new_costume_form_if_required_fields_empty and return
    # check if dancer info empty
    redirect_to_new_costume_form_if_assignment_incomplete and return
    # valid assignment(s)
    redirect_to_costume_path('Costume Successfully Created & Assigned!')
  end

  # Studio
  # Receives data from edit form
  # PATCH/PUT /costumes/:id
  def update
    return render :edit unless @costume.update(costume_params)

    redirect_to_costume_path('Costume Updated!')
  end

  # Studio
  # Deletes a costume and all associated costume assignments
  # DELETE /costumes/:id
  def destroy
    @costume.destroy

    redirect_to dance_studio_costumes_path(current_user), success: 'Costume Deleted'
  end

  # Studio
  # Displays form for a dance studio to assign a costume for a season
  # GET /costumes/:id/assign
  def assign_costume
    # get info to display if previously assigned
    @shared_info = @assignments.first
    # build an empty costume assignment to collect shared info
    @assignment_info = @costume.build_shared_assignment_info
    # build costume assignments w/ dancer_id to collect each dancer's info
    @costume.build_assignments_with_dancer_id(current_user)
  end

  # Studio
  # Receives data from assign costume form
  # POST /costumes/:id/assign
  def assign
    @previous_assignment_count = @costume.costume_assignments.count # gets no. of assignments before updating
    # check if the dance_season or song_name value is empty
    redirect_to_assign_costume_form_if_required_fields_empty and return
    # try to persist to db
    @updated = @costume.update(costume_params)
    # check that if updates, @costume.costume_assignments.count is now greater than count
    redirect_to_assign_costume_form_if_assignment_incomplete and return
    # redirect if updated correctly
    redirect_to_season_assignments_path_if_updated and return
    # redirect if costume assignments are invalid
    redirect_to assign_costume_path(@costume), danger: "Assignment failure: #{@costume.errors.full_messages.to_sentence}"
  end

  # Studio
  # Displays form for a dance studio to edit a costume's assignments for a season
  # params[:season]
  # GET /costumes/:id/edit_season_assignments
  def edit_season_assignments
    @costume.build_assignments_unless_exists(current_user, @assignments)
  end

  # Studio
  # Receives info from edit_season_assignments form
  # PATCH/PUT /costumes/:id/edit_season_assignments
  def update_season_assignments
    @costume.update(costume_params)

    redirect_to season_assignments_path(@costume, season: params[:costume][:costume_assignments_attributes].values[0].values[0])
  end

  private

  # before_action only: %i[show]
  # checks if costume belongs to studio or assigned to dancer
  def require_costume_ownership
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(set_costume)
  end

  # before_action only: %i[create assign]
  # gets shared assignment info to check if assigning / validate assignments
  def fetch_shared_assignment_info
    @assignment_info = params[:costume][:costume_assignments_attributes].permit!.to_h.first.pop
    # => {"dance_season"=>"", "song_name"=>"", "genre"=>"", "hair_accessory"=>"", "shoe"=>"", "tight"=>""}
    @dance_season_empty = @assignment_info[:dance_season].empty?
    @song_name_empty = @assignment_info[:song_name].empty?
  end

  # create & update helper
  # redirects to costume show page with message
  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  ## create action helpers
  # redirects to new costume form with message
  def redirect_to_new_costume_form(message)
    redirect_to new_dance_studio_costume_path(current_user.id), message
  end

  # redirects to costume show page if not assigning the new costume
  # checks if all shared assignment info fields are empty
  def redirect_to_costume_path_if_not_assigning
    redirect_to_costume_path('Costume Successfully Created!') if @assignment_info.values.all?('')
  end

  # redirects to new costume form if assigning costume & has shared info errors
  # checks if either the dance_season or song_name value is empty
  def redirect_to_new_costume_form_if_required_fields_empty
    redirect_to new_dance_studio_costume_path(current_user.id), danger: 'Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
  end

  # redirects to new costume form if assigning costume & has dancer info errors
  # checks if dancer info empty
  def redirect_to_new_costume_form_if_assignment_incomplete
    redirect_to_new_costume_form(danger: 'Must select at least 1 dancer w/ costume size & costume condition') if @costume.costume_assignments.empty?
  end

  ## assign action helper
  # redirects to assign costume form if has shared info errors
  # checks if either the dance_season or song_name value is empty
  def redirect_to_assign_costume_form_if_required_fields_empty
    if @costume.costume_assignments.empty?
      redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    else
      redirect_to assign_costume_path(@costume, season: @costume.costume_assignments.last.dance_season), danger: 'Assignment failure: Must fill out Dance Season & Song Name AND select at least 1 dancer w/ costume size & costume condition' if @dance_season_empty || @song_name_empty
    end
  end

  # redirects to costume season_assignments page if assignments updated
  def redirect_to_season_assignments_path_if_updated
    redirect_to season_assignments_path(@costume, season: @costume.costume_assignments.last.dance_season) if @updated
  end

  # redirects to assign costume form if assignments have dancer info errors
  # checks if @costume.costume_assignments.count is greater than previous_assignment_count
  def redirect_to_assign_costume_form_if_assignment_incomplete
    redirect_to assign_costume_path(@costume), danger: 'Assignment failure: Must also select at least 1 dancer w/ costume size & costume condition' if @updated && @previous_assignment_count == @costume.costume_assignments.count
  end

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :dance_studio_id, :costume_assignments_attributes => [:id, :dancer_id, :song_name, :dance_season, :genre, :hair_accessory, :shoe, :tight, :costume_size, :costume_condition])
  end
end
