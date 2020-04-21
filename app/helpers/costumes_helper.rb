module CostumesHelper
  def find_costume
    @costume = Costume.find(params[:id])
  end

  def redirect_to_costume_path(message)
    # path for Back button on costume show page
    @back_page = dance_studio_costumes_path(current_user)
    redirect_to costume_path(@costume, back_page: @back_page), success: message
  end
end
