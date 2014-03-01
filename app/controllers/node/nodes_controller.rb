# coding: utf-8
class Node::NodesController < ApplicationController
  include Cms::BaseFilter
  include Cms::NodeFilter
  
  model Cms::Node
  
  navi_view "node/main/navi"
  
  private
    def set_item
      super
      raise "404" if @item.id == @cur_node.id
    end
    
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
    def pre_params
      { route: "node/nodes" }
    end
    
  public
    def index
      @items = @model.site(@cur_site).node(@cur_node).
        order_by(filename: 1).
        page(params[:page]).per(100)
        
      @pages = Cms::Page.site(@cur_site).node(@cur_node).
        where(route: "cms/pages").
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
