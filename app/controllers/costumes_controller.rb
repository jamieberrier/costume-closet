class CostumesController < ApplicationController
  before_action :redirect_if_not_owner!, except: %i[show index]

  def new
    @costume = Costume.new(dance_studio_id: params[:dance_studio_id])
    @dance_studio = DanceStudio.find(params[:dance_studio_id])
  end

  def create
    @costume = Costume.new(costume_params)

    return redirect_to new_dance_studio_costume_path(current_user.id), danger: "Creation failure: #{@costume.errors.full_messages.to_sentence}" unless @costume.save

    redirect_to costume_path(@costume), success: "Costume Successfully Created!"
  end

  def show
    @costume = Costume.find(params[:id])
  end

  def index
    @costumes = current_user.costumes
  end

  def edit
    @costume = Costume.find(params[:id])
  end

  def update
    @costume = Costume.find(params[:id])

    return redirect_to edit_costume_path(@costume, dance_studio: current_user), danger: "Edit failure: #{@costume.errors.full_messages.to_sentence}" unless @costume.update(costume_params)

    redirect_to costume_path(@costume), success: "Costume Updated!"
  end

  def destroy
    @costume = Costume.find(params[:id])
    @costume.destroy
    redirect_to dance_studio_costumes_path(current_user), success: "Costume Deleted"
  end

  private

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :hair_accessory, :dance_studio_id)
  end
end
