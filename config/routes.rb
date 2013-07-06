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

  match "blog"      => "blog#index", as: :blogs
  match "blog/:id"  => "blog#show", as: :blog

  match 'auth/facebook/callback'        => 'social#facebook', :as => :facebook
  match 'auth/failure'                  => 'social#failure',  :as => :social_failure
  #match 'auth/twitter/callback'         => 'social#twitter',  :as => :twitter
  #match 'auth/google_oauth2/callback'   => 'social#google',   :as => :google
  #match 'auth/linkedin/callback'        => 'social#linkedin', :as => :linkedin  

end
