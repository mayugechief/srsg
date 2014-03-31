# coding: utf-8
SS::Application.routes.draw do
  
  Uploader::Initializer
  
  content "uploader" do
    get "/" => "main#index", as: :main
    resources :files
  end
end
