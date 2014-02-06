# coding: utf-8
Srsg::Application.routes.draw do
  
  Category::Node
  
  editor "category" do
    plugin "categories" 
  end
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resources :nodes, concerns: :deletion
    resources :pieces, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :configs, concerns: :deletion
  end
  
  node "category" do
    get "main/(index.:format)" => "public#index", cell: "node/main"
  end
  
end
