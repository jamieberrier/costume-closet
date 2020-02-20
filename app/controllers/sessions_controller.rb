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

  def destroy
    session.destroy
    redirect_to root_path, success: 'Successfully logged out!'
  end
end
