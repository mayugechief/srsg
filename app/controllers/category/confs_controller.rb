# coding: utf-8
class Category::ConfsController < ApplicationController
  include Cms::BaseFilter
  include Cms::NodeFilter
  
  model Category::Node
  
  navi_view "category/main/navi"
  menu_view "node/confs/menu"
  
  private
    def set_item
      @item = @cur_node
      @item.attributes = fix_params
    end
    
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node.parent }
    end
end