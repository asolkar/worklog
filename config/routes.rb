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
  match '/gpluscreate', to: 'users#create_from_gplus_id'
  match '/logout',      to: 'sessions#destroy'
  match '/profile',     to: 'users#show'

  #
  # Paths for user scoped access
  #
  scope '/:username', :constraints => ProfileConstraint do
    get '' => 'users#show', :as => 'user'
    put '' => 'users#update', :as => 'user'
    get 'edit' => 'users#edit', :as => 'edit_user'
    delete 'destory' => 'users#destroy', :as => 'destroy_user'
    resources :logs do
      resources :entries
    end
    resources :tags
    get 'logs/:id/tags/:name' => 'logs#show', :as => 'user_tagged_log'
  end
  resources :sessions
  resources :users, :only => [:create]

  #
  # Routes for Google+ Sign In
  #
  post "google_plus_sign_in/connect" => 'google_plus_sign_in#connect'
  get "google_plus_sign_in/disconnect" => 'google_plus_sign_in#disconnect'
end
