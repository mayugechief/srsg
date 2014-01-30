# coding: utf-8
Srsg::Application.routes.draw do
  
  Category::Node
  
  editor "category" do
    plugin "categories" 
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resources :nodes
  end
  
  node "category" do
    get "root/(index.:format)" => "public#index", cell: "node/root"
  end
  
end
