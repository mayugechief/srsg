# coding: utf-8
class Node::PartsController < ApplicationController
  before_action :redirect_index, only: :index
  
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Cms::PartFilter::Base
  
  model Cms::Part
  
  navi_view "node/main/navi"
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node
    end
  
    def redirect_index
      redirect_to node_layouts_path
    end
end
