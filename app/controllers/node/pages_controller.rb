# coding: utf-8
class Node::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  prepend_view_path "app/views/cms/pages"
  navi_view "node/main/navi"
  menu_view "cms/pages/menu"
  
  prepend_before_action :redirect_index, only: :index
  
  private
    def fix_params
      { site_id: @cur_site._id, cur_node: @cur_node }
    end
    
    def redirect_index
      redirect_to node_nodes_path
    end
end
