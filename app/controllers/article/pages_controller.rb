# coding: utf-8
class Article::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  navi_view "article/main/navi"
  menu_view "cms/pages/menu"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        desc(:updated).
        page(params[:page])
      
      render_crud
    end
end
