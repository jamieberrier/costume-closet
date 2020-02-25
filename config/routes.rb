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
    resources :dancers, only: %i[show edit update destroy]
    resources :costume_assignments
  end

  resources :dancers, only: %i[new create]

  # Routes for signing up dance studio
  get '/register/dance_studio' => 'dance_studios#new'
  get '/register/dance_studio/google' => 'dance_studios#googleAuth', as: 'dance_studio_google_register'
  # Routes for signing up dancer via Google
  get '/register/dancer/google' => 'dancers#googleAuth', as: 'dancer_google_register'
  # Routes for logging in
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
  # Routes for Google authentication
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('application#home')
end
