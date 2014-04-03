# coding: utf-8
SS::Application.routes.draw do

  Event::Prep

  concern :deletion do
    get :delete, on: :member
  end

  content "event" do
    get "/" => "main#index", as: :main
    resources :pages, concerns: :deletion
  end

  node "event" do
    get "pages/(index.:format)" => "public#index", cell: "node/pages"
    get "pages/:year:month.:format" => "public#index", cell: "node/pages",
      year: /\d{4}/, month: /\d{2}/
  end

end
