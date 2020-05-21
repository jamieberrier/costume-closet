class RegistrationsController < ApplicationController
  skip_before_action :require_logged_in

  # GET /register
  def new
    redirect_if_logged_in('You are already logged in')
    create_empty_user
  end

  private

  # Returns true if user_type is dance_studio
  def signing_up_as_dance_studio?
    params[:user_type] == 'dance_studio'
  end

  # Creates instance based on user_type
  def create_empty_user
    signing_up_as_dance_studio? ? @dance_studio = DanceStudio.new : @dancer = Dancer.new
  end
end
