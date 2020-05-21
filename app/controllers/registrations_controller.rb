class RegistrationsController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_if_logged_in('You are already logged in')
    create_empty_user
  end

  private

  def signing_up_as_dance_studio?
    params[:user_type] == 'dance_studio'
  end

  def create_empty_user
    signing_up_as_dance_studio? ? @dance_studio = DanceStudio.new : @dancer = Dancer.new
  end
end
