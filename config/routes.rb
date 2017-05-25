Rails.application.routes.draw do
  resources :users
  resources :reports, only: [:show, :new, :create, :edit, :destroy]
end
