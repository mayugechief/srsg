# coding: utf-8
class Node::PartsController < ApplicationController
  include Cms::BaseFilter
  include Cms::PartFilter
  
  prepend_before_action :redirect_index, only: :index
  
  model Cms::Part
  
  navi_view "node/main/navi"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
    def pre_params
      { route: "cms/frees" }
    end
    
    def redirect_index
      redirect_to node_layouts_path
    end
end
