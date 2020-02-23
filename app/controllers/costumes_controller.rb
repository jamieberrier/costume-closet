class CostumesController < ApplicationController
  def new
    @costume = Costume.new(dance_studio_id: params[:dance_studio_id])
  end

  def create
    @costume = Costume.new(costume_params)

    if @costume.save
      redirect_to dance_studio_costume_path(@costume, dance_studio_id: costume_params[:dance_studio_id])
    else
      render :new
    end
  end

  def show
    
  end

  private

  def costume_params
    params.require(:costume).permit(:top_description, :bottoms_description, :onepiece_description, :picture, :hair_accessory, :dance_studio_id)
  end

end
