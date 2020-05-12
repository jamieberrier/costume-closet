module DancersHelper
  # Studio & Dancer: params[:id] -> dancer id
  # dancers -- show edit update destroy dancer_assignments current_assignments
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path(message: "Only the dancer's studio can access") unless current_user.dancers.include?(find_dancer)
    else # check if dancer is current user
      redirect_to root_path(message: 'Denied access') unless current_user.id == params[:id].to_i
    end
  end

  def find_dancer
    @dancer = Dancer.find(params[:id])
  end

  ## create action helpers
  def redirect_studio_if_saved
    redirect_to_dance_studio_page('Dancer Added!') if @saved && owner?
  end

  def log_in_dancer_if_saved
    log_in(@dancer, 'Successfully Registered!') if @saved
  end
end
