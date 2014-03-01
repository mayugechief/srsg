# coding: utf-8
class Node::LayoutsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Layout
  
  navi_view "node/main/navi"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
  
  public
    def index
      @items = @model.site(@cur_site).node(@cur_node).
        order_by(filename: 1).
        page(params[:page]).per(20)
      
      @parts = Cms::Part.site(@cur_site).node(@cur_node).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
