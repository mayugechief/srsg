# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "sys", path: ".sys" do
    get "/" => "main#index", as: :main
    get "test" => "test#index", as: :test
    resources :users, concerns: :deletion
    resources :groups, concerns: :deletion
    resources :sites, concerns: :deletion
  end
  
end
