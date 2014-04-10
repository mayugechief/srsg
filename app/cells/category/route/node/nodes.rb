# coding: utf-8
module Category::Route::Node::Nodes
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Category::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Category::Node.site(@cur_site).node(@cur_node).my_route.
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
  end
end
