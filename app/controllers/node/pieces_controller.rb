# coding: utf-8
class Node::PiecesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Piece
  
  navi_view "node/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
  
  public
    def index
      @items = @model.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(depth: @cur_node.depth + 1).
        sort(name: 1)
      
      render_crud
    end
    
    #def new
    #  @item = @model.new filename: "#{@cur_node.filename}/"
    #  render_crud
    #end
end
