class SessionsController < ApplicationController
  before_action :require_logged_in!, only: [:destroy]

  def new
    redirect_if_logged_in!
  end

  def create
    # if email is blank, redirect to /login
    if params[:user][:email].blank?
      redirect_to_login(warning: 'Enter Email')
    else # find dance studio or dancer
      @dance_studio = DanceStudio.find_by(email: params[:user][:email])
      @dancer = Dancer.find_by(email: params[:user][:email])
      # try to authenticate password
      if !!@dance_studio
        try_to_authenticate(@dance_studio)
      elsif !!@dancer
        try_to_authenticate(@dancer)
      else # no dance studio/dancer found, redirect to /login
        redirect_to_login(danger: 'Incorrect Email')
      end
    end
  end

  def google_auth
    # Get access tokens from the google server
    # Access_token is used to authenticate request made from the rails application to the google server
    access_token = request.env["omniauth.auth"]
    user_type = request.env["omniauth.params"]["user_type"]
    session[:dance_studio] = nil
    session[:dancer] = nil

    if user_type == 'dance_studio'
      @dance_studio = DanceStudio.from_omniauth(access_token)
    else
      @dancer = Dancer.from_omniauth(access_token)
    end
    if !!@dance_studio
      if @dance_studio.id
        @dance_studio.save
        log_in(@dance_studio, 'Successfully logged in!')
      else # if signing up
        session[:dance_studio] = @dance_studio
        redirect_to dance_studio_google_register_path
      end
    else
      if @dancer.id
        @dancer.save
        log_in(@dancer, 'Successfully logged in!')
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
