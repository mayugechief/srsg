# coding: utf-8
module Node::Route::Node::Nodes
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Node::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Cms::Node.site(@cur_site).node(@cur_node).
        order_by(@cur_node.orders)
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
  end
end
