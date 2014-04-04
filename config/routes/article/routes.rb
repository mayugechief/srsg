# coding: utf-8
SS::Application.routes.draw do
  
  Article::Initializer
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "article" do
    get "/" => "main#index", as: :main
    resources :pages, concerns: :deletion
  end
  
  node "article" do
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
    get "pages/rss.xml" => "public#rss", cell: "node/pages", format: "xml"
  end
  
  part "article" do
    get "pages" => "public#index", cell: "part/pages"
  end
  
end
