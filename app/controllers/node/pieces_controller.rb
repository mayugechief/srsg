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
      redirect_to node_layouts_path
    end
end
