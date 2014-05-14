# coding: utf-8
class Cms::Node::LayoutsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Layout
  
  prepend_view_path "app/views/cms/layouts"
  navi_view "cms/node/main/navi"
  menu_view "cms/node/main/node_menu"
  
  private
    def fix_params
      { cur_user: @cur_user, cur_site: @cur_site, cur_node: @cur_node }
    end
  
  public
    def index
      @items = @model.site(@cur_site).node(@cur_node).allow(read: @cur_user).
        order_by(filename: 1).
        page(params[:page]).per(20)
    end
end
