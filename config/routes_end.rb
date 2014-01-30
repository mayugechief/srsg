# coding: utf-8
Srsg::Application.routes.draw do
  
  get "*path" => "cms/public#index"
  
  root "cms/public#index"
  
end
