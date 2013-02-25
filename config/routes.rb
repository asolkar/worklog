RorWorklog::Application.routes.draw do
  #
  # Paths
  #
  root :to => 'static_pages#home'

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/signup',  to: 'users#new'
  match '/login',   to: 'sessions#new'
  match '/logout',  to: 'sessions#destroy'

  match '/users/:username/edit', to: 'users#edit'
  match '/users/:username', to: 'users#update', :via => :put
  match '/users/:username', to: redirect { |params, req| "/#{params[:username]}" }

  #
  # Paths for user scoped access
  #
  scope '/:username', :constraints => ProfileConstraint do
    get '' => 'users#show'
    get 'edit' => 'users#edit'
    resources :logs do
      resources :entries
    end
  end
  resources :sessions
  resources :users do
    resources :logs do
      resources :entries
    end
  end

end
