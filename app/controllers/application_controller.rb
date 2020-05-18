class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :owner?, :dancer?

  add_flash_types :success, :danger, :warning, :info

  #include SessionsHelper
  #include RegistrationsHelper
  #include DancersHelper
  #include DanceStudiosHelper
  #include CostumesHelper
  #include CostumeAssignmentsHelper

  before_action :require_logged_in, except: :home

  def home
    if params[:message]
      message = params[:message]
    else
      message = 'You are already logged in'
    end

    redirect_if_logged_in(message)
  end

  # keeps track of/find the user currently logged in
  def current_user
    # if @current_user is assigned, don't evaluate
    if session[:user_type] == 'DanceStudio'
      @current_user ||= DanceStudio.find_by(id: session[:user_id])
    else
      @current_user ||= Dancer.find_by(id: session[:user_id])
    end
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

  private

   # redirects to home page if user is not logged in
   def require_logged_in
    return redirect_to root_path, danger: 'You are not logged in' unless logged_in?
  end

  # Owner
  # nested, params[:dance_studio_id] -> dance studio id
  # dancers -- new index current dancers
  # costumes -- new create index
  # costume assignments -- index
  def require_dance_studio_owner
    redirect_to root_path(message: 'Only studio owner can access') unless owner? && current_user.id == params[:dance_studio_id].to_i
  end
end
