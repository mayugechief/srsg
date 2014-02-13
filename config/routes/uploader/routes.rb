# coding: utf-8
SS::Application.routes.draw do
  
  content "uploader" do
    get "/" => "main#index", as: :main
    resources :files
  end
  
end
