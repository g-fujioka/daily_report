Rails.application.routes.draw do



  root 'reports#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :departments, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :reports do
    resources :comments, only:[:create, :destroy]
  end
end
