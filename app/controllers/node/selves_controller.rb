# coding: utf-8
class Node::SelvesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Cms::NodeFilter::Base
  
  model Cms::Node
  
  navi_view "node/main/navi"
  
  private
    def set_item
      @item = @cur_node
    end
    
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node.parent
    end
end
