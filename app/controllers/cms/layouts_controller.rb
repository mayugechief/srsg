# coding: utf-8
class Cms::LayoutsController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Cms::Layout
  
  crumb ->{ [:layouts, cms_layouts_path] }
  
  navi_view "cms/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: false
    end
    
  public
    def index
      @items = @model.site_is(@cur_site)
        .where(depth: 1)
        .sort(name: 1)
      
      render_crud
    end
end
