# coding: utf-8
class Cms::ContentsController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:contents, cms_contents_path]
    end
    
  public
    def index
      @model = Cms::Node
      
      @mod = params[:mod]
      cond = {}
      cond[:route] = /^#{@mod}\// if @mod.present?
      
      @items = Cms::Node.site_is(@cur_site).
        where(cond).
        where(shortcut: 1).
        sort(filename: 1)
    end
end
