require File.expand_path("../../lib/logged_in_constraint", __FILE__)

Fastspec::Application.routes.draw do
  #ActiveAdmin.routes(self)


  authenticated :user do
    root :to => 'dashboard#index'
  end

  root :to => "home#index"
  match 'dashboard' => "dashboard#index", as: 'dashboard'
  match 'home' => "home#index", as: 'home'

  
  devise_for :users
  resources :users, :only => [:show, :index]
  match 'user/rolify' => 'users#rolify'

  #devise_for :users, ActiveAdmin::Devise.config
  
  resources :projects
  resources :teams
  resources :features

  match 'projects/:id/add/feature/:feature_id' => 'projects#add_feature', as: 'project_add_feature'
  match 'projects/:id/delete/feature/:feature_id' => 'projects#delete_feature', as: 'project_delete_feature'
  match 'projects/:id/update/feature/:feature_id' => 'projects#update_feature', as: 'project_update_feature'
  match 'projects/:id/update/features' => 'projects#update_features', as: 'project_update_features'

  match 'projects/:id/share' => 'projects#share', as: 'share_project'
  match 'projects/:id/unshare' => 'projects#unshare', as: 'unshare_project'
  match 'p/:token' => 'projects#shared', as: 'shared_project'
  
  resources :invites
  match 'invite' => 'invites#new', as: 'new_invite'
  match 'reinvite/:token' => 'invites#reinvite', as: 'resend_invite'
  match 'join/:token' => 'invites#join', as: 'join_invite'

  match 'changelog' => 'changelog#index'

  namespace "api" do
    namespace "v1" do
      get "features" => "features#get"
      post 'project/feature' => 'features#add_feature_to_project'
      post 'project/feature/comment' => 'features#add_comment_to_feature'
      delete 'project/feature' => 'features#remove_feature_from_project'
      post 'project/feature/attach' => 'features#attach_picture_to_feature'
    end
    
  end

end
