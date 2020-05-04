class DancersController < ApplicationController
  skip_before_action :require_logged_in, only: :create
  before_action :require_dance_studio_owner, only: %i[new index current_dancers]
  before_action :require_studio_dancer, only: %i[show edit update destroy dancer_assignments current_assignments]

  # Owner
  # Displays from for a Dance Studio to create a new dancer
  # url: /dance_studios/1/dancers/new
  def new
    @dancer = Dancer.new(dance_studio_id: current_user.id, password: 'password', password_confirmation: 'password')
  end

  # Receives data from registrations/new (renders dancers/_form)
  # dance studio can also create dancer account: dancers/new (renders _form)
  def create
    @dancer = Dancer.new(dancer_params)

    if @dancer.save && owner?
      redirect_to_dance_studio_page('Dancer Added!')
    elsif @dancer.save
      log_in(@dancer, 'Successfully Registered!')
    elsif owner?
      render_new_form
    else
      render_registration_form(@dancer)
    end
  end

  # Display dancer's show page
  # dancer & dance studio can view
  # url: /dancers/1
  def show
    find_dancer
  end

  # Displays form to edit dancer's account info
  # dancer & dance studio can edit
  # url: /dancers/1/edit
  def edit
    find_dancer
  end

  # Receives data from edit form
  # dancer & dance studio can update
  def update
    find_dancer
    if @dancer.update(dancer_params)
      redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
    else
      render_edit_form
    end
  end

  # dancer viewing all costume assignments / owner viewing a dancer's costume assignments
  # url: /dancers/3/costume_assignments
  def dancer_assignments
    find_dancer
    @costume_assignments = CostumeAssignment.where(dancer_id: @dancer).order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # Displays dancer's current costume assignments with costume picture
  # dancer & dance studio can view
  # url: /dancers/1/current_assignments
  def current_assignments
    find_dancer
    @assignments = CostumeAssignment.current_dancer_costumes(@dancer)
  end

  # Owner
  # Displays all dancers for a dance studio
  # only dance_studio can view
  # url: /dance_studios/1/dancers
  def index
    # all dancers at a dance_studio
  end

  # Owner
  # Displays the current dancers for a dance studio
  # only dance studio can view
  # url: /dance_studios/1/dancers/current_dancers
  def current_dancers
    @dancers = Dancer.current_dancers(current_user)
  end

  # Deactivates dancer's account to keep costume assignment data
  # dancer & dance studio can deactivate
  def destroy
    find_dancer
    # set current_dancer to false & password/confirmation to 'dancer'
    @dancer.update(current_dancer: false, password: 'dancer', password_confirmation: 'dancer')

    if dancer?
      logout('Account Deactivated!')
    else # if studio owner deactivating a dancer account
      redirect_to_dance_studio_page('Account Deactivated')
    end
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
