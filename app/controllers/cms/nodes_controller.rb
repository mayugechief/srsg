# coding: utf-8
class Cms::NodesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Cms::Node
  
  crumb ->{ [:nodes, cms_nodes_path] }
  
  private
    def set_params
      data = super.merge site_id: @cur_site._id
      data[:type] ||= "root" if data[:route].present?
      data
    end
    
  public
    def index
      @items = @model.site_is(@cur_site).sort(filename: 1)
      render_crud
    end
end
