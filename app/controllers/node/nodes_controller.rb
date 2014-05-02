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
      raise "403" unless @cur_node.permitted?(user: @cur_user)

      @items = @model.site(@cur_site).node(@cur_node).
        where_permitted(user: @cur_user, site: @cur_site).
        order_by(filename: 1).
        page(params[:page]).per(50)
    end
end
