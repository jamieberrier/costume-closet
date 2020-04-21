class CostumesController < ApplicationController
  before_action :redirect_if_not_owner!, except: %i[show index]

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

  def show
    find_costume
  end

  def index
    @costumes = current_user.costumes
    # path for Back button on costume show page
    @back_page = dance_studio_costumes_path(current_user)
  end

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

    Dancer.current_dancers(current_user).each do |dancer|
      @costume.costume_assignments.build(dancer_id: dancer.id)
    end
  end

  # Receives data from costume assignment form
  def assign
    find_costume
    @costume.update(costume_params)
    redirect_to unassigned_costumes_path(current_user)
  end

  private

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :hair_accessory, :dance_studio_id, :costume_assignments_attributes => [:dancer_id, :song_name, :dance_season, :genre, :shoe, :tight, :costume_size, :costume_condition])
  end
end
