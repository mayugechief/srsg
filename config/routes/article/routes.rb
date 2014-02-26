# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "article" do
    get "/" => "main#index", as: :main
    resources :pages, concerns: :deletion
  end
  
  node "article" do
    addon :pages
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
  end
  
  part "article" do
    addon :pages
    get "pages" => "public#index", cell: "part/pages"
  end
  
end
