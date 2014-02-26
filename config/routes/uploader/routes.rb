# coding: utf-8
SS::Application.routes.draw do
  
  content "uploader" do
    get "/" => "main#index", as: :main
    resources :files
  end
  
  node "uploader" do
    addon :files
  end
end
