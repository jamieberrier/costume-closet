Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Root route
  root 'application#home'

  # Shallow nested routes, nests: index create new
  resources :dance_studios, except: %i[new index], shallow: true do
    resources :costumes
    resources :dancers, except: %i[create]
    resources :costume_assignments, only: %i[index]
    # Route for dance studio to view their current dancers
    get '/dancers/current_dancers' => 'dancers#current_dancers', as: 'current_dancers'
  end

  post '/dancers' => 'dancers#create'

  # Routes for a dancer
  scope '/dancers/:id' do
    # Route for dancers to view all their costume assignments
    get '/costume_assignments' => 'dancers#dancer_assignments', as: 'dancer_costumes'
    # Route for dancer to view their current costume asignments
    get '/current_assignments' => 'dancers#current_assignments', as: 'dancer_current_assignments'
  end

  # Routes for a dance studio
  scope '/dance_studios/:id' do
    # Route for dance studio to view their current costume assignments
    get '/current_assignments' => 'dance_studios#current_assignments', as: 'studio_current_assignments'
    # Route for dance studio to view the costumes currently in use
    get '/current_costumes' => 'dance_studios#current_costumes', as: 'studio_current_costumes'
    # Route for dance studio to view the costumes not currently in use
    get '/unassigned_costumes' => 'dance_studios#unassigned_costumes', as: 'unassigned_costumes'
  end
  scope '/costumes/:id' do
    # Routes for dance studio to assign a costume to dancers
    get '/assign' => 'costumes#assign_costume', as: 'assign_costume'
    patch '/assign' => 'costumes#assign'
    post '/assign' => 'costumes#assign'
    # Route for a dance studio to view all of a costume's assignments
    get '/assignments' => 'costume_assignments#costume_assignments', as: 'assigned_costume'
    # Route for a dance studio to view a costume's season assignments
    get '/season_assignments' => 'costume_assignments#season_assignments', as: 'season_assignments'
    # Route for a dance studio to delete a costume's season assignments
    delete '/season_assignments' => 'costume_assignments#delete_season_assignments'
    # Routes for a dance studio to edit a costume's season assignments
    get '/edit_season_assignments' => 'costumes#edit_season_assignments', as: 'edit_season_assignments'
    patch '/edit_season_assignments' => 'costumes#update_season_assignments'
    post '/edit_season_assignments' => 'costumes#update_season_assignments'
  end

  # Route for signing up a user (dance_studio & dancer)
  get '/register' => 'registrations#new'

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
