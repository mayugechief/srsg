# coding: utf-8
class Cms::Node::ConfsController < ApplicationController
  include Cms::BaseFilter
  include Cms::NodeFilter
  
  model Cms::Node
  
  navi_view "cms/node/main/navi"
  
  private
    def set_item
      @item = @cur_node
      @item.attributes = fix_params
    end
    
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node.parent }
    end
    
    def redirect_url
      if params[:action] == "destroy"
        return cms_nodes_path unless @item.parent
        node_nodes_path(cid: @item.parent)
      else
        { action: :show, cid: @item }
      end
    end
end
