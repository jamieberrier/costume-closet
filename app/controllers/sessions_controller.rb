class SessionsController < ApplicationController
  def new
  end

  def create
    # if email is blank, redirect to /login
    if params[:dance_studio][:email].blank?
      redirect_to login_path, warning: 'Enter Email'
    else # find dance studio & try to authenticate password
      @dance_studio = DanceStudio.find_by(email: params[:dance_studio][:email])
      # try is an ActiveSupport method: object.try(:some_method) means if object != nil then object.some_method else nil end.
      authenticated = @dance_studio.try(:authenticate, params[:dance_studio][:password])
      # if no dance studio found, redirect to /login
      if @dance_studio.nil?
        redirect_to login_path, danger: 'Incorrect Email'
      else # not be able to log in if password is incorrect
        if authenticated
          session[:user_id] = @dance_studio.id
          redirect_to dance_studio_path(@dance_studio), success: 'Successfully logged in!'
        else
          redirect_to login_path, danger: 'Invalid Password'
        end
      end
    end
  end

  def googleAuth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    dance_studio = DanceStudio.from_omniauth(access_token)
    # log_in(dance_studio)
    # Access_token is used to authenticate request made from the rails application to the google server
    # Only save the token if you are planning to use Google APIs (Calendar, Spreadsheet.. etc)
    # dance_studio.google_token = access_token.credentials.token

    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    dance_studio.google_refresh_token = refresh_token if refresh_token.present?
    dance_studio.save
    binding.pry
    # redirect_to root_path
    redirect_to dance_studio_path(dance_studio), success: 'Successfully logged in!'
  end

  def destroy
    session.destroy
    redirect_to root_path, success: 'Successfully logged out!'
  end

end
