Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Root route
  root 'application#home'

  # Shallow nested routes, nests: index create new
  resources :dance_studios, only: %i[create show edit update destroy], shallow: true do
    resources :costumes
    resources :dancers, only: %i[new index show edit update destroy]
    resources :costume_assignments, only: %i[index]
  end

  post '/dancers' => 'dancers#create'

  # Routes for a dancer
  scope '/dancers/:id' do
    # Route for dancers to view all their costume assignments
    get '/costume_assignments' => 'costume_assignments#dancer_assignments', as: 'dancer_costumes'
    # Route for dancer to view their current costume asignments
    get '/current_assignments' => 'dancers#current_assignments', as: 'dancer_current_assignments'
  end

  # Routes for a dance studio
  scope '/dance_studios/:id' do
    # Route for dance studio to view their current costume assignments
    get '/current_assignments' => 'dance_studios#current_assignments', as: 'studio_current_assignments'
    # Route for dance studio to view their current dancers
    get '/dancers/current_dancers' => 'dancers#current_dancers', as: 'studio_current_dancers'
    # Route for dance studio to view the costumes currently in use
    get '/current_costumes' => 'dance_studios#current_costumes', as: 'studio_current_costumes'
    # Route for dance studio to view the costumes not currently in use
    get '/unassigned_costumes' => 'dance_studios#unassigned_costumes', as: 'unassigned_costumes'
  end
  scope '/costumes/:id' do
    # Route for a dance studio to view all of a costume's assignments
    get '/assignments' => 'costume_assignments#costume_assignments', as: 'assigned_costume'
    # Route for a dance studio to view a costume's assignments for a season
    get '/season_assignments' => 'costume_assignments#season_assignments', as: 'season_assignments'
    # Routes for dance studio to assign a costume to dancers
    get '/assign' => 'costumes#assign_costume', as: 'assign_costume'
    patch '/assign' => 'costumes#assign'
    post '/assign' => 'costumes#assign'
  end

  # Route for signing up a user (dance_studio & dancer)
  get '/register' => 'registrations#new'
  # Route for signing up as a dance_studio via google
  get '/register/dance_studio/google' => 'registrations#google_auth', as: 'dance_studio_google_register'
  # Route for signing up as a dancer via google
  get '/register/dancer/google' => 'registrations#google_auth', as: 'dancer_google_register'

  # Routes for logging in
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  # Routes for Google authentication
  get 'auth/google_oauth2', as: 'google_omniauth'
  get 'auth/:provider/callback', to: 'sessions#google_auth'
  get 'auth/failure', to: redirect('application#home')
end

# You can have the root of your site routed with "root":
# root 'welcome#index'

# Example of regular route:
# get 'products/:id' => 'catalog#view'

# Example of Custom Route:
# get "students/:id/activate" => "students#activate", as: "activate_student"
