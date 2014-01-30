# coding: utf-8
class Category::NodesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Category::Node
  
  crumb ->{ [:contents, cms_contents_path] }
  crumb ->{ [@cur_node.name, category_main_path] }
  crumb ->{ [:categories, category_nodes_path] }
  
  private
    def set_params
      super.merge site_id: @cur_site._id, cur_node: @cur_node, type: :item
    end
    
  public
    def index
      @items = @model
        .site_is(@cur_site)
        .where(filename: /^#{@cur_node.filename}\//)
        .sort(filename: 1)
      
      render_crud
    end
    
    def new
      @item = @model.new filename: "#{@cur_node.filename}/"
      render_crud
    end
end
