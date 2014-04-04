# coding: utf-8
SS::Application.routes.draw do

  Uploader::Initializer

  content "uploader" do
    get "/" => "main#index", as: :main

    resources :files, only: [:index]
    resource :files, path: '/files/*filename', as: :files,
      only: [:create, :show, :destroy, :update], format: false
  end
end
