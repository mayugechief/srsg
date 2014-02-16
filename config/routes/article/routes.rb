# coding: utf-8
SS::Application.routes.draw do
  
  Cms::Node.route "article/pages"
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "article" do
    get "/" => "main#index", as: :main
    resources :pages, concerns: :deletion
  end
  
  node "article" do
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
  end
  
  piece "article" do
    get "pages" => "public#index", cell: "piece/pages"
  end
  
end
