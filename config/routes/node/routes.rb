# coding: utf-8
SS::Application.routes.draw do
  
  Node::Initializer
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "node" do
    get "/" => "main#index", as: :main
    resource :conf, concerns: :deletion
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :parts, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :roles, concerns: :deletion
  end
  
  node "node" do
    get "nodes/(index.:format)" => "public#index", cell: "node/nodes"
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
    get "pages/rss.xml" => "public#rss", cell: "node/pages", format: "xml"
  end
  
  part "node" do
    get "nodes" => "public#index", cell: "part/nodes"
    get "pages" => "public#index", cell: "part/pages"
  end
end
