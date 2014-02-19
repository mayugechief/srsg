# coding: utf-8
class Category::SelvesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Category::Node
  
  navi_view "category/main/navi"
  menu_view "node/selves/menu"
  
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
