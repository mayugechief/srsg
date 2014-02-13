# coding: utf-8
SS::Application.routes.draw do
  
  get "*path" => "cms/public#index"
  
  root "cms/public#index"
  
end
