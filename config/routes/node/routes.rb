# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, on: :member
  end
  
  concern :conf do
    collection do
      resource :conf, concerns: :deletion
    end
  end
  
  content "node" do
    get "/" => "main#index", as: :main
    resource :conf, concerns: :deletion, path: "nodes/conf"
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :parts, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :roles, concerns: :deletion
  end
  
end
