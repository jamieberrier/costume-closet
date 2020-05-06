module CostumesHelper
  def find_costume
    @costume = Costume.find(params[:id])
  end

  def redirect_to_costume_path(message)
    redirect_to costume_path(@costume), success: message
  end

  # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
  def build_assignments_with_dancer_id
    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id)
    end
  end

  # build a costume_assignments record unless one with dancer's id already exists
  def build_assignments_unless_exists
    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id) unless @assignments.exists?(dancer_id: dancer.id)
    end
  end

  def find_season_costume_assignments
    @season = params[:season]
    @assignments = CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", @costume.id, @season)
  end

  def update_costume
    @costume.update(costume_params)
  end

  # instanstiates an empty instance of costume assignment - to collect the shared data for the assignments
  def build_shared_assignment_info
    @assignment_info = @costume.costume_assignments.build
  end

  # Owner
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign costume_assignments season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  def require_studio_costume
    redirect_to root_path(message: 'Only costume owner can access') unless owner? && current_user.costumes.include?(find_costume)
  end

  # Owner & Dancer: params[:id] -> costume id
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(find_costume)
  end
end
