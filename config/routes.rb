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

  resources :ads
  resources :users
  resources :regions, :only => [:index]
  resources :categories, :only => [:index, :show]
  
  match "favorites/:id" => "favorites#toggle", as: :toggle
  
  match "dispatch_email/:id", to: "ads#dispatch_email",  as: "dispatch_email", method: :post

  match "blog"      => "blog#index", as: :blogs
  match "blog/:id"  => "blog#show", as: :blog

end
