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
      raise "403" unless  @cur_user.my_site?(@cur_site)
      
      @model = Cms::Node
      
      @mod = params[:mod]
      cond = {}
      cond[:route] = /^#{@mod}\// if @mod.present?
      
      @items = Cms::Node.site(@cur_site).
        where(cond).
        where(shortcut: :show).
        where_permitted(site: @cur_site, user: @cur_user).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
