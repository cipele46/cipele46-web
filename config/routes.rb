Cipele46Web::Application.routes.draw do
  get "categories/index"

  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  get 'home' => 'home#index'
  devise_for :users
  ActiveAdmin.routes(self)
  resources :ads, :only => [:create, :edit, :new, :show, :update]
  resources :users
  resources :regions, :only => [:index]
  resources :categories, :only => [:index]
end