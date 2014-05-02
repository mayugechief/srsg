# coding: utf-8
SS::Application.routes.draw do
    
  Acl::Initializer
  
  concern :deletion do
    get :delete, on: :member
  end
  
  namespace "acl", path: ".:host" do
    get "/" => "main#index", as: :main
  end

  namespace "acl", path: ".:host/acl" do
    get "/" => "main#index"
    get "/entries/select_group_users" => "entries#select_group_users" do 
      member do 
        get 'select_group_users'
      end
    end
    resources :entries, concerns: :deletion
  end
end
