require File.expand_path("../../lib/logged_in_constraint", __FILE__)

Fastspec::Application.routes.draw do
  ActiveAdmin.routes(self)

  #devise_for :users, ActiveAdmin::Devise.config

  authenticated :user do
    root :to => 'dashboard#index'
  end

  #root :to => "home#index"
  root :to => "home#index"
  match 'dashboard' => "dashboard#index", as: 'dashboard'

  
  devise_for :users
  resources :users, :only => [:show, :index]
  
  resources :projects
  resources :teams
  resources :features

  match 'projects/:id/add/feature/:feature_id' => 'projects#add_feature', as: 'project_add_feature'
  match 'projects/:id/delete/feature/:feature_id' => 'projects#delete_feature', as: 'project_delete_feature'
  match 'projects/:id/update/feature/:feature_id' => 'projects#update_feature', as: 'project_update_feature'
  match 'join/team/:id/:token' => 'invite#join_team', as: 'join_team'
  
  resources :invites
  match 'invite' => 'invites#new', as: 'new_invite'

  namespace "api" do
    namespace "v1" do
      get "features" => "features#get"
    end
    
  end

end
