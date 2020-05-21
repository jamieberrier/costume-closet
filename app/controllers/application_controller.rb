class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :owner?, :dancer?

  add_flash_types :success, :danger, :warning, :info

  before_action :require_logged_in, except: :home

  def home
    params[:message] ? message = params[:message] : message = 'You are already logged in'

    redirect_if_logged_in(message)
  end

  # redirects to home page if user is not logged in
  def require_logged_in
    return redirect_to root_path, danger: 'You are not logged in' unless logged_in?
  end

  private

  def render_registration_form
    render 'registrations/new'
  end

  def redirect_to_dance_studio_page(message)
    redirect_to dance_studio_path(current_user), success: message
  end

  # keeps track of/find the user currently logged in
  def current_user
    # if @current_user is assigned, don't evaluate
    session[:user_type] == 'DanceStudio' ? @current_user ||= DanceStudio.find_by(id: session[:user_id]) : @current_user ||= Dancer.find_by(id: session[:user_id])
  end

  # checks if the user is logged in
  def logged_in?
    !!current_user
  end

  # checks if the user is an owner
  def owner?
    session[:user_type] == 'DanceStudio' if current_user
  end

  # checks if the user is a dancer
  def dancer?
    session[:user_type] == 'Dancer' if current_user
  end

  # redirects to login path if login failure
  def redirect_to_login(message)
    redirect_to login_path, warning: message
  end

  # tries to authenticate password & logs user in if authenticated
  def try_to_authenticate(user)
    # try is an ActiveSupport method: object.try(:some_method) means if object != nil then object.some_method else nil end.
    authenticated = user.try(:authenticate, params[:password])

    authenticated ? log_in(user, 'Successfully Logged In!') : redirect_to_login('Invalid Password')
  end

  # logs in user and redirects based on type of user
  def log_in(user, message)
    session[:user_id] = user.id
    session[:user_type] = user.class.name

    return redirect_to dance_studio_path(user), success: message if owner?

    redirect_to dancer_path(user), success: message if dancer?
  end

  # redirects to user show page based on type of user
  def redirect_if_logged_in(message)
    if owner?
      redirect_to dance_studio_path(current_user), warning: message if logged_in?
    else
      redirect_to dancer_path(current_user), warning: message if logged_in?
    end
  end

  def redirect_if_not_owner
    redirect_to dancer_path(current_user) unless owner?
  end

  def redirect_if_not_dancer
    redirect_to dance_studio_path(current_user) unless dancer?
  end

  def logout(message)
    # reset session
    reset_session
    # redirect to home page
    redirect_to root_path, success: message
  end

  # Studio
  # nested, params[:dance_studio_id] -> dance studio id
  # dancers -- new index current dancers
  # costumes -- new create index
  # costume assignments -- index
  def require_dance_studio_owner
    redirect_to root_path(message: 'Only studio owner can access') unless owner? && current_user.id == params[:dance_studio_id].to_i
  end

  # Studio
  # unnested, params[:id] -> dance studio id
  # dance_studios -- show edit update destroy current_assignments current_costumes unassigned_costumes
  def require_studio_ownership
    redirect_to root_path(message: 'Only dance studio owner can access') unless owner? && current_user.id == params[:id].to_i
  end

  # Studio & Dancer: params[:id] -> dancer id
  # dancers -- show edit update destroy dancer_assignments current_assignments
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path(message: "Only the dancer's studio can access") unless current_user.dancers.include?(set_dancer)
    else # check if dancer is current user
      redirect_to root_path(message: 'Denied access') unless current_user.id == params[:id].to_i
    end
  end

  # Studio & Dancer: params[:id] -> costume id
  # costumes -- show
  def require_costume_ownership
    # check if costume belongs to studio or assigned to dancer
    redirect_to root_path(message: 'Only can owner or assigned dancer can access') unless current_user.costumes.include?(set_costume)
  end

  # Studio
  # no dance studio id, params[:id] -> costume id
  # costumes -- edit update destroy assign_costume assign costume_assignments season_assignments edit_eason_assignments update_season_assignments delete_season_assignments
  def require_studio_costume
    redirect_to root_path(message: 'Only costume owner can access') unless owner? && current_user.costumes.include?(set_costume)
  end

  # costumes & costume assignments before_action
  def set_costume
    @costume = Costume.find(params[:id])
  end

  # costumes & costume assignments before_action only: %i[season_assignments edit_season_assignments delete_season_assignments assign_costume]
  def set_season_costume_assignments
    @season = params[:season]
    @assignments = CostumeAssignment.season_assignments(params)
  end

  # costumes & costume assignments before_action only: %i[season_assignments edit_season_assignments]
  def set_shared_info
    @shared_info = @costume.shared_assignment_info(@assignments.first)
  end
end
