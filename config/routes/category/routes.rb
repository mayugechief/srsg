# coding: utf-8
SS::Application.routes.draw do
  
  Category::Node
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resource :conf, concerns: :deletion, path: "nodes/conf"
    resources :nodes, concerns: :deletion
  end
  
  node "category" do
    addon :nodes
    addon :pages
    get "nodes/(index.:format)" => "public#index", cell: "node/nodes"
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
  end
  
  part "category" do
    addon :nodes
  end
end
