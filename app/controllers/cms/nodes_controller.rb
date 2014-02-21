# coding: utf-8
class Cms::NodesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Cms::NodeFilter::Base
  
  model Cms::Node
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:nodes, action: :index]
    end
    
    def set_params
      super.merge site_id: @cur_site._id, cur_node: false
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(depth: 1).
        sort(filename: 1).
        limit(200)
      
      render_crud
    end
end
