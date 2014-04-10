# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "sns_user", path: ".u:user", module: "sns/user", user: /\d+/ do
    get "/" => "main#index"
    
    resource :profile
    resource :account
    
    resources :files, concerns: :deletion do
      get :view, on: :member
      get :thumb, on: :member
      get :download, on: :member
    end
  end
  
end
