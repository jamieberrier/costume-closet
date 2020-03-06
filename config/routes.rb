Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # You can have the root of your site routed with "root"
  #   root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of Custom Route:
  #   get "students/:id/activate" => "students#activate", as: "activate_student"

  # root route
  root 'application#home'

  resources :dance_studios, only: %i[create show edit update destroy] do
    resources :costumes
    resources :dancers
    resources :costume_assignments
  end

  resources :dancers, only: [:create] do
    get '/costume_assignments' => 'costume_assignments#index', as: 'costumes'
    get '/costume_assignments/:id' => 'costume_assignments#show', as: 'costume'
  end

  # Routes for signing up a dance studio
  get '/register/dance_studio' => 'registrations#new'
  get '/register/dance_studio/google' => 'registrations#google_auth', as: 'dance_studio_google_register'
  # Routes for signing up a dancer
  get '/register/dancer' => 'registrations#new'
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
