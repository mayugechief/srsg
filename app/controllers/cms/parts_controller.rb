# coding: utf-8
class Cms::PartsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Cms::PartFilter::Base
  
  model Cms::Part
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:parts, action: :index]
    end
    
    def set_params
      super.merge site_id: @cur_site._id, cur_node: false
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(depth: 1).
        sort(filename: 1)
      
      render_crud
    end
end
