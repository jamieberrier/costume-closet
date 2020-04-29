class CostumesController < ApplicationController
  # can I delete redirect_if_not_owner ??
  # before_action :redirect_if_not_owner!, except: :show
  before_action :redirect_if_not_studio_owner!, only: %i[new create index]
  before_action :redirect_if_not_assigned!, except: %i[new create index]

  # Dance Studio & Dancer can view
  def show
    find_costume
  end

  def new
    @costume = Costume.new(dance_studio_id: params[:dance_studio_id])
    # instanstiates an empty instance of costume assignment - to collect the shared data for the assignments
    @assignment_info = @costume.costume_assignments.build
    # instanstiates an instance of costume assignment for each current dancer w/ the dancer's id
    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id)
    end
  end

  def create
    # params[:costume] -> {"dance_studio_id"=>"1", top_description"=>"", "bottoms_description"=>"", "onepiece_description"=>"nvkdsn;kbv", "hair_accessory"=>"none", "picture"=>"", "costume_assignments_attributes"=>{"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}}} permitted: false>
    # params[:costume][:costume_assignments_attributes] -> {"0"=>{"dance_season"=>"2020", "song_name"=>"test", "genre"=>"lyrical", "shoe"=>"none", "tight"=>"none"}, "7"=>{"dancer_id"=>"1", "costume_size"=>"S"}, "8"=>{"dancer_id"=>"2", "costume_size"=>"M"}, "9"=>{"dancer_id"=>"3", "costume_size"=>"M"}, "10"=>{"dancer_id"=>"0", "costume_size"=>""}, "11"=>{"dancer_id"=>"0", "costume_size"=>""}} permitted: false>
    @costume = Costume.new(costume_params)

    return redirect_to new_dance_studio_costume_path(current_user.id), danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}" unless @costume.save

    redirect_to_costume_path('Costume Successfully Created!')
  end

  def index
    @costumes = current_user.costumes
  end

  # can edit studio id in url
  def edit
    find_costume
  end

  def update
    find_costume
    return redirect_to edit_costume_path(@costume, dance_studio: current_user), danger: "Edit failure: #{@costume.errors.full_messages.to_sentence}" unless @costume.update(costume_params)

    redirect_to_costume_path('Costume Updated!')
  end

  def destroy
    find_costume
    @costume.destroy
    redirect_to dance_studio_costumes_path(current_user), success: 'Costume Deleted'
  end

  # Displays form to assign a costume
  def assign_costume
    find_costume
    @assignment_info = @costume.costume_assignments.build
    @season = Time.now.year

    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id)
    end
  end

  # Receives data from costume assignment form
  def assign
    find_costume
    @costume.update(costume_params)
    redirect_to season_assignments_path(@costume, season: params[:costume][:costume_assignments_attributes]['0'][:dance_season])
  end

  # owner viewing a costume's assignments for a season
  # params[:season]
  def season_assignments
    find_costume
    @season = params[:season]
    @costume_assignments = CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", @costume.id, @season)
  end

  # Displays form for owner to edit a costume's assignments for a season
  # params[:season]
  def edit_season_assignments
    find_costume
    @season = params[:season]
    @assignments = CostumeAssignment.where("costume_id = '%s' and dance_season = '%s'", @costume.id, @season)
    @assignment_info = @costume.costume_assignments.build(hair_accessory: @assignments.first.hair_accessory, tight: @assignments.first.tight, shoe: @assignments.first.shoe, genre: @assignments.first.genre, song_name: @assignments.first.song_name, costume_id: @costume.id, dance_season: @season, id: nil, dancer_id: nil, costume_size: nil, costume_condition: nil)

    Dancer.current_dancers(current_user).each do |dancer|
      # build a record unless one with dancer's id already exists
      @costume.costume_assignments.build(dancer_id: dancer.id) unless @assignments.exists?(dancer_id: dancer.id)
    end
  end

  def update_season_assignments
    find_costume
    @costume.update(costume_params)
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
