# coding: utf-8
SS::Application.routes.draw do
  
  Cms::Node.route "uploader/files"
  
  content "uploader" do
    get "/" => "main#index", as: :main
    resources :files
  end
  
end
