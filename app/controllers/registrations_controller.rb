class RegistrationsController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_if_logged_in('You are already logged in')
    create_empty_user
  end
end
