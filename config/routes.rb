Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :questions, except: [:show, :new, :index]
  resources :hashtags, param: :id, only: :show
end
