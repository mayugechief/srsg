# coding: utf-8
class Cms::ContentsController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  
  private
    #def set_crumbs
    #  @crumbs << [:contents, action: :index]
    #end
    
  public
    def index
      @model = Cms::Node
      
      @mod = params[:mod]
      cond = {}
      cond[:route] = /^#{@mod}\// if @mod.present?
      
      @items = Cms::Node.site(@cur_site).
        where(cond).
        where(shortcut: 1).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
