# coding: utf-8
class Sys::SitesController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter
  
  model SS::Site
  
  navi_view "sys/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:sites, sys_sites_path]
    end
  
  public
    def index
      @items = @model.all
      render_crud
    end
end
