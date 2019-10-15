Rails.application.routes.draw do
  root :to => "people#index"
  resources :affiliations
  resources :locations
  resources :imports, only: [:new, :create, :index]
  resources :people, only: [:index, :show]
end
