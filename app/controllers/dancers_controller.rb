class DancersController < ApplicationController
  skip_before_action :require_logged_in!, only: :create
  # For Dance Studio to create a new dancer
  def new
    @dancer = Dancer.new(dance_studio_id: current_user.id, password: 'test', password_confirmation: 'test')
  end

  def create
    @dancer = Dancer.new(dancer_params)
    
    if owner?
      flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"
      render 'dancers/new' unless @dancer.save

      redirect_to dance_studio_path(current_user), success: 'Dancer Added!'
    else
      #try_to_save(@dancer)
      #log_in(@dancer, 'Successfully Registered!')
      if @dancer.save
        log_in(@dancer, 'Successfully Registered!')
      else
        flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"
        render 'registrations/new'
      end
    end
  end

  def show
    find_dancer
  end

  def edit
    find_dancer
  end

  def update
    find_dancer
    @dancer.update(dancer_params)
    redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
  end

  def index 

  end

  def destroy
    find_dancer
    # set current_dancer to false & password/confirmation to "..."
    @dancer.update(current_dancer: false, password: "...", password_confirmation: "...")

    if dancer?
      # reset session
      reset_session
      # redirect to home page
      redirect_to root_path, success: 'Account Deactivated!'
    else # if studio owner deactivating a dancer account
      # redirect to studio page
      redirect_to dance_studio_path(current_user), success: 'Account Deactivated!'
    end
  end
  # Gets current costume assignments
  def current_assignments
    @assignments = CostumeAssignment.current_dancer_costumes(current_user)
  end
  # Gets current dancers for a dance studio
  def current_dancers
    @dancers = Dancer.current_dancers(current_user)
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
