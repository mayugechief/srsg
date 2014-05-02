# coding: utf-8
class Node::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  prepend_view_path "app/views/cms/pages"
  navi_view "node/main/navi"
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
  public
    def index
      raise "403" unless @cur_node.permitted?(user: @cur_user)
      
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        where(route: "cms/pages").
        where_permitted(user: @cur_user, site: @cur_site).
        order_by(filename: 1).
        page(params[:page]).per(50)
    end
end
