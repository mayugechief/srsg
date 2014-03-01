# coding: utf-8
SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "cms", path: ".:host" do
    get "/" => "main#index", as: :main
    #get "/" => "contents#index", as: :main
  end
  
  namespace "cms", path: ".:host/cms" do
    get "/" => "main#index"
    resources :contents, path: "contents/(:mod)"
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :parts, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :roles, concerns: :deletion
  end
  
  part "cms" do
    addon :frees
  end
  
  editor "cms" do
    addon :basic
    addon :html
    addon :tiny
    addon :wiki
  end
  
end
