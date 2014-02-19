# coding: utf-8
class Node::SelvesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Node
  
  navi_view "node/main/navi"
  
  private
    def set_item
      @item = @cur_node
    end
    
  public
    def destroy
      parent = @cur_node.parent
      url = parent ? { controller: :nodes, cid: parent } : cms_nodes_path
      
      @item.destroy
      respond_to do |format|
        format.html { redirect_to url, notice: "Destroyed." }
        format.json { head :no_content }
      end
    end
end
