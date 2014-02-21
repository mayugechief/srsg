# coding: utf-8
class Node::PagesController < ApplicationController
  before_action :redirect_index, only: :index
  
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  navi_view "node/main/navi"
  menu_view "cms/pages/menu"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
    
    def redirect_index
      redirect_to node_nodes_path
    end
end
