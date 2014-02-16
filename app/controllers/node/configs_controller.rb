# coding: utf-8
class Node::ConfigsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Node
  
  navi_view "node/main/navi"
  menu_view "node/config/menu"
  
  private
    def set_item
      @item = @cur_node
    end
    
  public
    def destroy
      parent = @cur_node.parent
      url = parent ? node_nodes_path(cid: parent.id) : cms_nodes_path
      
      @item.destroy
      respond_to do |format|
        format.html { redirect_to(url, notice: "Destroyed.") }
        format.json { head :no_content }
      end
    end
end
