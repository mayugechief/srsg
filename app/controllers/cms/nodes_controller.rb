# coding: utf-8
class Cms::NodesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Cms::Node
  
  crumb ->{ [:nodes, cms_nodes_path] }
  
  navi_view "cms/main/navi"
  
  private
    def set_params
      data = super.merge site_id: @cur_site._id
      data[:type] ||= "main" if data[:route].present?
      data
    end
    
  public
    def index
      if params[:node_id]
        @node = Cms::Node.find(params[:node_id])
        cond = { filename: /^#{@node.filename}\//, depth: @node.depth + 1 }
      else
        cond = { depth: 1 }
      end
      
      @items = @model.site_is(@cur_site).where(cond).sort(filename: 1)
      render_crud
    end
end
