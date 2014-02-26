# coding: utf-8
SS::Application.routes.draw do
  
  #dump "--" * 5
  #eval "module ::Node::Category; end"
  Cms::Node.addons.each do |addon|
    #name = addon[1]
    #dump path = "node/#{name}"
    #dump klass = "/node/#{name}_controller".camelize
    #src  = []
    #src << "class #{klass} < ApplicationController"
    #src << "  include Cms::BaseFilter"
    #src << "  include Cms::CrudFilter"
    #src << "end"
    #eval src.join("\n")
    #base = File.basename(name)
    #resource base, path: ".:host/node:cid/config/#{name}", controller: path
    #dump({ base: base, path: ".:host/node:cid/config/#{name}", controller: path })
  end
  
  get "*public_path" => "cms/public#index", public_path: /[^\.].*/
  
  root "cms/public#index"
  
end
