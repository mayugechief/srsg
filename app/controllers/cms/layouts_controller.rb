# coding: utf-8
class Cms::LayoutsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Layout
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:layouts, cms_layouts_path]
    end
    
    def set_params
      super.merge site_id: @cur_site._id, cur_node: false
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(depth: 1).
        sort(name: 1)
      
      render_crud
    end
end
