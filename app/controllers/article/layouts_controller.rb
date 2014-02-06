# coding: utf-8
class Article::LayoutsController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Cms::Layout
  
  crumb ->{ [@cur_node.name, article_main_path] }
  crumb ->{ [:layouts, article_layouts_path] }
  
  navi_view "article/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
  
  public
    def index
      @items = @model.site_is(@cur_site)
        .where(filename: /^#{@cur_node.filename}\//)
        .sort(name: 1)
      
      render_crud
    end
end
