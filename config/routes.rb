Rails.application.routes.draw do
  root 'application#home'

  resources :costume_assignments
  resources :costumes
  resources :dancers
  resources :dance_studios

  get '/register' => 'dance_studios#new'
  post '/register' => 'dance_studios#create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
