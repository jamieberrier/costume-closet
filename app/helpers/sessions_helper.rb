module SessionsHelper
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

  # redirects to home page if user is not logged in
  def require_logged_in
    return redirect_to login_path, danger: 'You are not logged in' unless logged_in?
  end

  # redirects to login path if login failure
  def redirect_to_login(message)
    redirect_to login_path, message
  end

  # tries to authenticate password & logs user in if authenticated
  def try_to_authenticate(user)
    # try is an ActiveSupport method: object.try(:some_method) means if object != nil then object.some_method else nil end.
    authenticated = user.try(:authenticate, params[:user][:password])

    if authenticated
      log_in(user, 'Successfully Logged In!')
    else
      @user = user
      flash.now[:warning] = 'Invalid Password'
      render :new
    end
  end

  # checks if the user is an owner
  def owner?
    session[:user_type] == 'DanceStudio' if current_user
  end

  # checks if the user is a dancer
  def dancer?
    session[:user_type] == 'Dancer' if current_user
  end

  # logs in user and redirects based on type of user
  def log_in(user, message)
    session[:user_id] = user.id
    session[:user_type] = user.class.name

    redirect_owner_after_login(user, message) && return
    redirect_dancer_after_login(user, message)
  end

  def redirect_owner_after_login(user, message)
    redirect_to dance_studio_path(user), success: message if owner?
  end

  def redirect_dancer_after_login(user, message)
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
end
