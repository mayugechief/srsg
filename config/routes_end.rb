# coding: utf-8
SS::Application.routes.draw do
  
  get "*public_path" => "cms/public#index", public_path: /[^\.].*/
  
  root "cms/public#index"
  
end
