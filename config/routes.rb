Rails.application.routes.draw do
  get 'sessions/new'

  resources :users
  resources :reports, only: [:show, :new, :create, :edit, :destroy]
end
