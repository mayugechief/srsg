# coding: utf-8
SS::Application.routes.draw do
  
  Category::Prep
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "category" do
    get "/" => "main#index", as: :main
    resource :conf, concerns: :deletion, path: "nodes/conf"
    resources :nodes, concerns: :deletion
  end
  
  node "category" do
    get "nodes/(index.:format)" => "public#index", cell: "node/nodes"
    get "nodes/rss.xml" => "public#rss", cell: "node/pages", format: "xml"
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
    get "pages/rss.xml" => "public#rss", cell: "node/pages", format: "xml"
  end
  
  part "category" do
    get "nodes" => "public#index", cell: "part/nodes"
  end
  
end
