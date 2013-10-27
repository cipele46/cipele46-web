Cipele46Web::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "ads#index"

  ActiveAdmin.routes(self)

  authenticated :user do
    root :to => 'ads#index'
  end
  get 'home' => 'ads#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :ads do
    put :toggle
    put :close
  end

  resource :user, :only => [:new, :show, :update]
  resources :regions, :only => [:index]
  resources :categories, :only => [:index, :show]
  resources :blog, :only => [:index, :show]

  match "dispatch_email/:id", to: "ads#dispatch_email",  as: "dispatch_email", method: :post

  mount Api::Base => "/api", as: "api"
end
