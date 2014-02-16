# coding: utf-8
SS::Application.routes.draw do
  
  Category::Node
  
  Cms::Node.route "category/nodes"
  Cms::Node.route "category/pages"
  
  editor "category" do
    plugin "categories" 
  end
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resources :nodes, concerns: :deletion
  end
  
  node "category" do
    get "nodes/(index.:format)" => "public#index", cell: "node/nodes"
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
  end
  
end
