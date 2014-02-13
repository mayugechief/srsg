# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, on: :member
  end
  
  content "article" do
    get "/" => "main#index", as: :main
    resources :pages, concerns: :deletion
    resources :pieces, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :configs, concerns: :deletion
  end
  
  node "article" do
    get "main/(index.:format)" => "public#index", cell: "node/main"
  end
  
  piece "article" do
    get "pages" => "public#index", cell: "piece/pages"
  end
  
end
