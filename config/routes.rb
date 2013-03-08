RorWorklog::Application.routes.draw do
  #
  # Paths
  #
  root :to => 'users#show', :constraints => lambda { |req| !req.session[:user_id].blank? }
  root :to => 'static_pages#home', :constraints => lambda { |req| req.session[:user_id].blank? }

  match '/home',        to: 'static_pages#home'
  match '/help',        to: 'static_pages#help'
  match '/signup',      to: 'users#new'
  match '/login',       to: 'sessions#new'
  match '/gplussignin', to: 'sessions#gpluscreate'
  match '/gplusassoc',  to: 'users#associate_gplus_id'
  match '/logout',      to: 'sessions#destroy'
  match '/profile',     to: 'users#show'

  #
  # Paths for user scoped access
  #
  scope '/:username', :constraints => ProfileConstraint do
    get '' => 'users#show'
    put '' => 'users#update'
    get 'edit' => 'users#edit'
    resources :logs do
      resources :entries
    end
    resources :tags
    get 'logs/:id/tags/:name' => 'logs#show', :as => 'user_tagged_log'
  end
  resources :sessions
  resources :users do
    resources :logs do
      resources :entries
    end
  end

  #
  # Routes for Google+ Sign In
  #
  post "google_plus_sign_in/connect" => 'google_plus_sign_in#connect'
  get "google_plus_sign_in/disconnect" => 'google_plus_sign_in#disconnect'
end
