Cipele46Web::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "ads#index"

  ActiveAdmin.routes(self)

  authenticated :user do
    root :to => 'ads#index'
  end
  get 'home' => 'ads#index'
  devise_for :users

  resources :ads
  resource :user, :only => [:new, :show, :update]
  resources :regions, :only => [:index]
  resources :categories, :only => [:index, :show]

  match "favorites/toggle/:id" => "favorites#toggle", as: :toggle
  
  match "dispatch_email/:id", to: "ads#dispatch_email",  as: "dispatch_email", method: :post

  match "blog"      => "blog#index", as: :blogs
  match "blog/:id"  => "blog#show", as: :blog

  match 'auth/facebook/callback'        => 'social#facebook', :as => :facebook
  match 'auth/failure'                  => 'social#failure',  :as => :social_failure
  #match 'auth/twitter/callback'         => 'social#twitter',  :as => :twitter
  #match 'auth/google_oauth2/callback'   => 'social#google',   :as => :google
  #match 'auth/linkedin/callback'        => 'social#linkedin', :as => :linkedin

end
