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
  
  resources :invites
  match 'invite' => 'invites#new', as: 'new_invite'
  match 'join/:token' => 'invites#join', as: 'join_invite'

  match 'changelog' => 'changelog#index'

  namespace "api" do
    namespace "v1" do
      get "features" => "features#get"
      post 'project/feature' => 'features#add_feature_to_project'
      post 'project/feature/comment' => 'features#add_comment_to_feature'
    end
    
  end

end
