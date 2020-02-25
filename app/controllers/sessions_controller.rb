class SessionsController < ApplicationController
  before_action :require_logged_in!, only: [:destroy]

  def new
    redirect_if_logged_in
  end

  def create
    # if email is blank, redirect to /login
    if params[:user][:email].blank?
      redirect_to login_path, warning: 'Enter Email'
    else # find dance studio or dancer
      @dance_studio = DanceStudio.find_by(email: params[:user][:email])
      @dancer = Dancer.find_by(email: params[:user][:email])
      # try to authenticate password
        # try is an ActiveSupport method: object.try(:some_method) means if object != nil then object.some_method else nil end.
      if @dance_studio
        authenticated = @dance_studio.try(:authenticate, params[:user][:password])
        if authenticated
          log_in(@dance_studio, 'Successfully Logged In!')
        else
          redirect_to login_path, danger: 'Invalid Password'
        end
      elsif @dancer
        authenticated = @dancer.try(:authenticate, params[:user][:password])
        if authenticated
          log_in(@dancer, 'Successfully Logged In!')
        else
          redirect_to login_path, danger: 'Invalid Password'
        end
      else # no dance studio/dancer found, redirect to /login
        redirect_to login_path, danger: 'Incorrect Email'
      end
    end
  end

  def googleAuth
    # Get access tokens from the google server
    # Access_token is used to authenticate request made from the rails application to the google server
    access_token = request.env["omniauth.auth"]

    @dance_studio = DanceStudio.from_omniauth(access_token)
    @dancer = Dancer.from_omniauth(access_token)

    if @dancer_studio
      if @dance_studio.id
        @dance_studio.save
        log_in(@dance_studio, 'Successfully Logged In!')
      else # if signing up
        session[:dance_studio] = @dance_studio
        redirect_to dance_studio_google_register_path
      end
    elsif @dancer
      if @dancer.id
        @dancer.save
        log_in(@dancer, 'Successfully Logged In!')
      else # if signing up
        session[:dancer] = @dancer
        redirect_to dancer_google_register_path
      end
    end
  end

  def destroy
    session.destroy
    redirect_to root_path, success: 'Successfully logged out!'
  end
end
