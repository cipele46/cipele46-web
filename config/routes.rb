Cipele46Web::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: { registrations: 'registrations', :omniauth_callbacks => 'users/omniauth_callbacks' }
  
  root :to => "ads#index"

  ActiveAdmin.routes(self)

  authenticated :user do
    root :to => 'ads#index'
  end
  get 'home' => 'ads#index'

  resources :ads do
    put :toggle
    put :close
    post :reply
    collection do
      get :my
    end
  end

  resource :user, :only => [:new, :show, :update]
  resources :regions, :only => [:index]
  resources :categories, :only => [:index, :show]
  resources :blog, :only => [:index, :show]

  mount Api::Base => "/api", as: "api"
end
