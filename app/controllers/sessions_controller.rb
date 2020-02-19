class SessionsController < ApplicationController
  def new
  end

  def create
    @dance_studio = DanceStudio.find_by(email: params[:dance_studio][:email])
    # try is an ActiveSupport method
    # object.try(:some_method) means
    # if object != nil then object.some_method else nil end.
    authenticated = @dance_studio.try(:authenticate, params[:dance_studio][:password])

    if @dance_studio.nil?
      redirect_to login_path, danger: 'Enter Email'
    else
      # Users should not be able to log in if they enter an incorrect password.
      # @dance_studio.authenticated(params[:dance_studio][:password])
      if authenticated
        session[:user_id] = @dance_studio.id
        redirect_to dance_studio_path(@dance_studio.id), success: 'Successfully logged in!'
      else
        redirect_to login_path, info: 'Invalid Password'
      end
    end
  end

  def destroy
    session.destroy
    redirect_to root_path, success: 'Successfully logged out!'
  end
end
