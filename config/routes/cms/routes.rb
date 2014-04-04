# coding: utf-8
SS::Application.routes.draw do
  
  Cms::Initializer
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "cms", path: ".:host" do
    get "/" => "main#index", as: :main
    get ".preview/(*path)" => "preview#index", as: :preview
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
  
end
