
Rails.application.routes.draw do
  get 'sessions/new'

  root to: 'static_pages#home'
  get 'signup',  to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :followings, :followers, :favorites
    end
  end
  
  resources :microposts do
  member do
    get :favorite, :unfavorite
  end
end
  
  resources :sessions, only: [:new, :create, :destroy]
  
  resources :relationships, only: [:create, :destroy]
  
  resources :favorites, only: [:create, :destroy]
  
  
end
