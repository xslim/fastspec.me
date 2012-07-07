Fastspec::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  
  devise_for :users
  resources :users, :only => [:show, :index]
  
  resources :projects

  match 'projects/:id/add/feature/:feature_id' => 'projects#add_feature', as: 'project_add_feature'
  match 'projects/:id/delete/feature/:feature_id' => 'projects#delete_feature', as: 'project_delete_feature'
  match 'projects/:id/update/feature/:feature_id' => 'projects#update_feature', as: 'project_update_feature'

end
