# coding: utf-8
class Cms::LayoutsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Layout
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:layouts, action: :index]
    end
    
    def fix_params
      { site_id: @cur_site._id, cur_node: false }
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(depth: 1).
        sort(filename: 1)
    end
end
