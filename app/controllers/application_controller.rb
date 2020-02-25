class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  add_flash_types :success, :danger, :warning, :info

  include SessionsHelper

  def home
    redirect_to dance_studio_path(current_user), info: "You are already logged in" unless !logged_in?
  end
end
