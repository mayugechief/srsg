# coding: utf-8
class Node::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  navi_view "node/main/navi"
  menu_view "cms/pages/menu"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
  public
    def index
      redirect_to node_nodes_path
    end
end
