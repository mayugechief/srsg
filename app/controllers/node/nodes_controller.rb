# coding: utf-8
class Node::NodesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Cms::NodeFilter::Base
  
  model Cms::Node
  
  navi_view "node/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
    def set_item
      super
      raise "404" if @item.id == @cur_node.id
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(depth: @cur_node.depth + 1).
        sort(filename: 1).
        limit(100)
        
      @pages = Cms::Page.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(depth: @cur_node.depth + 1).
        where(route: "cms/pages").
        sort(filename: 1).
        limit(200)
      
      render_crud
    end
end
