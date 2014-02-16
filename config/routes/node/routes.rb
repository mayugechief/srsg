# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "node" do
    get "/" => "main#index", as: :main
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :pieces, concerns: :deletion
    resources :roles, concerns: :deletion
    resource :config, concerns: :deletion
  end
  
end