# coding: utf-8
Srsg::Application.routes.draw do
  
  content "uploader" do
    get "/" => "main#index", as: :main
    resources :files
  end
  
end
