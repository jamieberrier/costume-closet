module SessionsHelper
  # keeps track of/find the user currently logged in
  def current_user
    # if @current_user is assigned, don't evaluate
    @current_user ||= DanceStudio.find_by(id: session[:user_id]) == "DanceStudio"

    @current_user ||= Dancer.find_by(id: session[:user_id]) if session[:class] == "Dancer"
  end
  # checks if the user is logged in
  def logged_in?
    !!current_user
  end
  # redirects to home page if user is not logged in
  def require_logged_in!
    return redirect_to login_path, danger: "You are not logged in" unless logged_in?
  end
  # logs in user
  def log_in(user, message)
    session[:user_id] = user.id
    session[:class] = user.class.name
    # redirects based on type of user
    redirect_to dance_studio_path(user), success: message if is_owner?
    redirect_to dance_studio_dancer_path(user.dance_studio_id, user), success: message if is_dancer?
  end
  # checks if the user is an owner
  def is_owner?
    current_user.class.name == "DanceStudio" if current_user
  end
  # checks id the user is a dancer
  def is_dancer? 
    current_user.class.name == "Dancer" if current_user
  end
  # 
  def redirect_if_logged_in
    if is_owner?
      redirect_to dance_studio_path(current_user), info: "You are already logged in" unless !logged_in?
    else
      redirect_to dance_studio_dancer_path(current_user.dance_studio_id, current_user), info: "You are already logged in" unless !logged_in?
    end
  end

  def redirect_if_not_owner!
    redirect to dance_studio_dancer_path(current_user.dance_studio_id, current_user) if !is_owner?
  end
end
