Cipele46Web::Application.routes.draw do
  get "categories/index"

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "home#index"

  ActiveAdmin.routes(self)

  authenticated :user do
    root :to => 'home#index'
  end
  get 'home' => 'home#index'
  devise_for :users

  resources :ads, :only => [:index, :create, :edit, :new, :show, :update]
  resources :users
  resources :regions, :only => [:index]
  resources :categories, :only => [:index, :show]
  
  match "favorites/:id" => "favorites#toggle", as: :toggle

end
