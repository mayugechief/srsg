# coding: utf-8
Srsg::Application.routes.draw do
  
  content "article" do
    get "/" => "main#index", as: :main
    resources :pages
  end
  
  node "article" do
    get "root/(index.:format)" => "public#index", cell: "node/root"
  end
  
  piece "article" do
    get "pages" => "public#index", cell: "piece/pages"
  end
  
end
