# coding: utf-8
SS::Application.routes.draw do
  
  Category::Node
  
  Cms::Node.route "category/nodes"
  Cms::Node.route "category/pages"
  
  Cms::Page.addon "category/categories"
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resource :self, concerns: :deletion, path: "nodes/self"
    resources :nodes, concerns: :deletion
  end
  
  node "category" do
    get "nodes/(index.:format)" => "public#index", cell: "node/nodes"
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
  end
  
end
