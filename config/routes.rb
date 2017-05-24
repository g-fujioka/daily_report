Rails.application.routes.draw do
  get 'reports/new'

  resources :users
end
