class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]

  def new
    redirect_if_logged_in
  end

  def create
    # if email is blank, redirect to /login
    if params[:dance_studio][:email].blank?
      redirect_to login_path, warning: 'Enter Email'
    else # find dance studio & try to authenticate password
      @dance_studio = DanceStudio.find_by(email: params[:dance_studio][:email])
      # try is an ActiveSupport method: object.try(:some_method) means if object != nil then object.some_method else nil end.
      authenticated = @dance_studio.try(:authenticate, params[:dance_studio][:password])

      if @dance_studio.nil? # if no dance studio found, redirect to /login
        redirect_to login_path, danger: 'Incorrect Email'
      else # check for correct password & log in
        if authenticated
          log_in(@dance_studio, 'Successfully Logged In!')
        else
          redirect_to login_path, danger: 'Invalid Password'
        end
      end
    end
  end

  def googleAuth
    # Get access tokens from the google server
    # Access_token is used to authenticate request made from the rails application to the google server
    access_token = request.env["omniauth.auth"]
    @dance_studio = DanceStudio.from_omniauth(access_token)
    if @dance_studio.id
      @dance_studio.save
      log_in(@dance_studio, 'Successfully Logged In!')
    else
      session[:dance_studio] = @dance_studio
      redirect_to google_register_path
    end
  end

  def destroy
    session.destroy
    redirect_to root_path, success: 'Successfully logged out!'
  end
end
