# coding: utf-8
class Cms::Node::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  prepend_view_path "app/views/cms/pages"
  navi_view "cms/node/main/navi"
  menu_view "cms/node/main/node_menu"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
    def pre_params
      { layout_id: @cur_node.layout_id }
    end
    
  public
    def index
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        where(route: "cms/page").
        order_by(filename: 1).
        page(params[:page]).per(50)
    end
end
