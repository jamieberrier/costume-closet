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

  # Dancer & Owner
  # Dancer: receives data from registrations/new (renders dancers/_form)
  # Dance Studio: receives data from dancers/new (renders _form)
  def create
    @dancer = Dancer.new(dancer_params)
    saved = @dancer.save

    return redirect_to_dance_studio_page('Dancer Added!') if saved && owner?

    return log_in(@dancer, 'Successfully Registered!') if saved

    return render_new_dancer_form if owner?

    render_registration_form(@dancer)
  end

  # Dancer & Owner
  # Display dancer's show page
  # url: /dancers/1
  def show
    find_dancer
  end

  # Dancer
  # Displays form to edit dancer's account info
  # url: /dancers/1/edit
  def edit
    find_dancer
  end

  # Dancer
  # Receives data from edit form
  def update
    find_dancer

    return render_edit_dancer_form unless @dancer.update(dancer_params)

    redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
  end

  # Dancer & Owner
  # Displays all of dancer's costume assignments
  # url: /dancers/3/costume_assignments
  def dancer_assignments
    find_dancer
    @assignments = CostumeAssignment.where(dancer_id: @dancer).order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # Dancer & Owner
  # Displays dancer's current costume assignments with costume picture
  # url: /dancers/1/current_assignments
  def current_assignments
    find_dancer
    @assignments = CostumeAssignment.current_dancer_costumes(@dancer)
  end

  # Owner
  # Displays all dancers for a dance studio
  # url: /dance_studios/1/dancers
  def index
    @dancers = current_user.dancers.order(:last_name, :first_name)
  end

  # Owner
  # Displays the current dancers for a dance studio
  # url: /dance_studios/1/dancers/current_dancers
  def current_dancers
    @dancers = Dancer.current_dancers(current_user).order(:last_name, :first_name)
  end

  # Dancer & Owner
  # Deactivates dancer's account to keep costume assignment data
  def destroy
    find_dancer
    # set current_dancer to false & password/confirmation to 'dancer'
    @dancer.update(current_dancer: false, password: 'dancer', password_confirmation: 'dancer')

    return redirect_to_dance_studio_page('Account Deactivated') unless dancer?

    logout('Account Deactivated!')
  end

  private

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
