# coding: utf-8
class Category::NodesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Category::Node
  
  navi_view "category/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        sort(filename: 1)
      
      render_crud
    end
    
    def new
      @item = @model.new route: "category/nodes"
      render_crud
    end
end
