Rails.application.routes.draw do
  resources :costume_assignments
  resources :costumes
  resources :dancers
  resources :dance_studios
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
