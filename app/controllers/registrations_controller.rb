class RegistrationsController < ApplicationController
  skip_before_action :require_logged_in!, only: %i[new google_auth]

  def new
    redirect_if_logged_in!
    create_empty_user
  end

  def google_auth
    if session[:dance_studio]
      @dance_studio = DanceStudio.new(session[:dance_studio])
    else
      @dancer = Dancer.new(session[:dancer])
    end
  end
end
