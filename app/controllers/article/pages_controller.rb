# coding: utf-8
class Article::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  append_view_path "app/views/cms/pages"
  navi_view "article/main/navi"
  menu_view "cms/pages/menu"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node, route: "article/pages" }
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(route: "article/pages").
        order_by(updated: -1).
        page(params[:page])
    end
end
