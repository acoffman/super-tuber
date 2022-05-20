Rails.application.routes.draw do
  root "videos#index"

  resources :videos, only: [:index, :show, :update, :destroy] do
    get 'new', on: :collection
    get 'watched', on: :collection
    get 'saved', on: :collection
  end

  resources :channels, only: [:new, :create, :index, :destroy, :update] do
    get '/videos' => 'videos#new'
    get '/videos/new' => 'videos#new'
    get '/videos/watched' => 'videos#watched'
    get '/videos/saved' => 'videos#saved'
  end

  resource :login, only: [:new, :create, :destroy], controller: 'login'
end
