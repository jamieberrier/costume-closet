module SessionsHelper
  # keeps track of/find the user currently logged in
  def current_user
    # if @current_user is assigned, don't evaluate
    @current_user ||= DanceStudio.find_by(id: session[:user_id])
  end
  # checks if the user is logged in
  def logged_in?
    !!current_user
  end
  # redirects to home page if user is not logged in
  def require_logged_in
    return redirect_to root_path unless logged_in?
  end
  # logs in user
  def log_in(dance_studio)
    session[:user_id] = dance_studio.id
    redirect_to dance_studio_path(dance_studio), success: 'You are logged in!'
  end
end
