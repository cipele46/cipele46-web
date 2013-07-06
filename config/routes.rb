Cipele46Web::Application.routes.draw do
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
end