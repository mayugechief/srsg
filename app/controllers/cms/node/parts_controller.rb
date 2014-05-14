# coding: utf-8
class Cms::Node::PartsController < ApplicationController
  include Cms::BaseFilter
  include Cms::PartFilter
  
  model Cms::Part
  
  prepend_view_path "app/views/cms/parts"
  navi_view "cms/node/main/navi"
  menu_view "cms/node/main/node_menu"
  
  private
    def fix_params
      { cur_user: @cur_user, cur_site: @cur_site, cur_node: @cur_node }
    end
    
    def pre_params
      { route: "cms/free" }
    end
    
  public
    def index
      @items = Cms::Part.site(@cur_site).node(@cur_node).allow(read: @cur_user).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
