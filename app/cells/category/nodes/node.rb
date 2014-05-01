# coding: utf-8
module Category::Nodes::Node
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Category::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      cond = { filename: /^#{@cur_node.filename}\//, depth: @cur_node.depth + 1 }
      
      @items = Category::Node::Base.site(@cur_site).public.
        where(cond).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
  end
end
