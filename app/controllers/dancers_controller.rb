class DancersController < ApplicationController
  skip_before_action :require_logged_in, only: :create
  before_action :require_dance_studio_owner, only: %i[new index current_dancers]
  before_action :require_studio_dancer, except: %i[new create index current_dancers]
  before_action :set_dancer, except: %i[new create index current_dancers]

  # Studio
  # Displays all dancers for a dance studio
  # GET /dance_studios/:dance_studio_id/dancers
  def index
    @dancers = current_user.dancers.order(:last_name, :first_name)
  end

  # Dancer & Studio
  # Display dancer's show page
  # GET /dancers/:id
  def show; end

  # Studio
  # Displays form for a dance studio to create a new dancer
  # GET /dance_studios/:dance_studio_id/dancers/new
  def new
    @dancer = Dancer.new(dance_studio_id: current_user.id, password: 'password', password_confirmation: 'password')
  end

  # Dancer
  # Displays form to edit dancer's account info
  # GET /dancers/:id/edit
  def edit; end

  # Dancer & Studio
  # Dancer: receives data from registrations/new (renders dancers/_form)
  # Dance Studio: receives data from dancers/new (renders _form)
  # POST /dancers
  def create
    @dancer = Dancer.new(dancer_params)
    @saved = @dancer.save

    redirect_studio_if_saved && return

    log_in_dancer_if_saved && return

    return render :new if owner?

    render_registration_form
  end

  # Dancer
  # Receives data from edit form
  # PATCH/PUT /dancers/:id
  def update
    return render :edit unless @dancer.update(dancer_params)

    redirect_to dancer_path(@dancer), success: 'Account Info Updated!'
  end

  # Dancer & Studio
  # Deactivates dancer's account to keep costume assignment data
  # DELETE /dancers/:id
  def destroy
    # set current_dancer to false & password/confirmation to 'dancer'
    @dancer.update(current_dancer: false, password: 'dancer', password_confirmation: 'dancer')

    return redirect_to_dance_studio_page('Account Deactivated') unless dancer?

    logout('Account Deactivated!')
  end

  # Dancer & Studio
  # Displays all of dancer's costume assignments
  # GET /dancers/:id/costume_assignments
  def dancer_assignments
    @assignments = CostumeAssignment.where(dancer_id: @dancer).order(dance_season: :desc, genre: :asc, song_name: :asc)
  end

  # Dancer & Studio
  # Displays dancer's current costume assignments with costume picture
  # GET /dancers/:id/current_assignments
  def current_assignments
    @assignments = @dancer.costume_assignments.current_assignments
  end

  # Studio
  # Displays the current dancers for a dance studio
  # GET /dance_studios/:dance_studio_id/dancers/current_dancers
  def current_dancers
    @dancers = current_user.dancers.current_dancers.order(:last_name, :first_name)
  end

  private

  # before_action except: %i[new create index current_dancers]
  def set_dancer
    @dancer = Dancer.find(params[:id])
  end

  # before_action except: %i[new create index current_dancers]
  def require_studio_dancer
    if owner? # check if dancer belongs to studio
      redirect_to root_path(message: "Only the dancer's studio can access") unless current_user.dancers.include?(set_dancer)
    else # check if dancer is current user
      redirect_to root_path(message: 'Denied access') unless current_user.id == params[:id].to_i
    end
  end

  ## create action helpers
  # Dance Studio successfully adding a dancer
  def redirect_studio_if_saved
    redirect_to_dance_studio_page('Dancer Added!') if @saved && owner?
  end

  # Dancer successfully registering
  def log_in_dancer_if_saved
    log_in(@dancer, 'Successfully Registered!') if @saved
  end

  def dancer_params
    params.require(:dancer).permit(:dance_studio_id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
