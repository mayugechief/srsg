# coding: utf-8
class Sys::SitesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Sys::BaseFilter
  
  model SS::Site
  
  public
    def index
      @items = @model.all
      render_crud
    end
end
