class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :danger, :warning, :info

  include SessionsHelper
  include RegistrationsHelper
  include DancersHelper
  include DanceStudiosHelper

  before_action :require_logged_in!, except: :home

  def home
    redirect_if_logged_in!
  end
end
