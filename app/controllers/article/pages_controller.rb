# coding: utf-8
class Article::PagesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Cms::Page
  
  crumb ->{ [@cur_node.name, article_main_path] }
  crumb ->{ [:pages, article_pages_path] }
  
  navi_view "article/main/navi"
  menu_view "cms/pages/menu"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
  public
    def index
      @items = @model.site_is(@cur_site)
        .where(filename: /^#{@cur_node.filename}\//)
        .sort(updated: -1)
      
      render_crud
    end
end
