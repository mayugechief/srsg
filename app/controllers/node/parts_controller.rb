# coding: utf-8
class Node::PartsController < ApplicationController
  include Cms::BaseFilter
  include Cms::PartFilter
  
  model Cms::Part
  
  prepend_view_path "app/views/cms/parts"
  navi_view "node/main/navi"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
    def pre_params
      { route: "cms/frees" }
    end
    
  public
    def index
      @items = Cms::Part.site(@cur_site).node(@cur_node).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
