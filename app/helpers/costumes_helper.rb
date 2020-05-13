module CostumesHelper
  # Studio & Dancer: params[:id] -> costume id
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(find_costume)
  end

  # Studio
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign costume_assignments season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  def require_studio_costume
    redirect_to root_path(message: 'Only costume owner can access') unless owner? && current_user.costumes.include?(find_costume)
  end

  def find_costume
    @costume = Costume.find(params[:id])
  end

  def find_season_costume_assignments
    @season = params[:season]
    @assignments = CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", @costume.id, @season)
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
    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id) unless @assignments.exists?(dancer_id: dancer.id)
    end
  end

  def update_costume
    @costume.update(costume_params)
  end

  # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
  def unassigned?
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  ## create action helpers
  def redirect_to_new_costume_form(message)
    redirect_to new_dance_studio_costume_path(current_user.id), message
  end

  def redirect_if_validation_error
    redirect_to_new_costume_form(danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}") unless @costume.save
  end

  def redirect_if_not_assigning
    redirect_to_costume_path('Costume Successfully Created!') if @assignment_info.values.all?('')
  end

  def redirect_if_no_assignments
    redirect_to_new_costume_form(danger: 'dancer info failure') if @costume.costume_assignments.empty?
  end

  ## create & assign action helpers
  # gets shared assignment info
  def fetch_shared_info
    @assignment_info = params[:costume][:costume_assignments_attributes].permit!.to_h.first.pop
    # => {"dance_season"=>"", "song_name"=>"", "genre"=>"", "hair_accessory"=>"", "shoe"=>"", "tight"=>""}
    @dance_season_empty = @assignment_info[:dance_season].empty?
    @song_name_empty = @assignment_info[:song_name].empty?
    @count = @costume.costume_assignments.count # gets no. of assignments before updating
  end

  # checks if the dance_season or song_name value is empty
  def redirect_if_required_values_empty
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
end
