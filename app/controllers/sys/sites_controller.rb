# coding: utf-8
class Sys::SitesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Sys::BaseFilter
  
  model SS::Site
  
  crumb ->{ [:sites, sys_sites_path] }
  
  navi_view "sys/main/navi"
  
  public
    def index
      @items = @model.all
      render_crud
    end
end
