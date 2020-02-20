Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # You can have the root of your site routed with "root"
  #   root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of Custom Route:
  #   get "students/:id/activate", to: "students#activate", as: "activate_student"

  root 'application#home'

  resources :costume_assignments
  resources :costumes
  resources :dancers
  resources :dance_studios, only: [:create, :index, :edit, :show, :update, :destroy]

  get '/register' => 'dance_studios#new'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
end
