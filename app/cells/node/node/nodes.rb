# coding: utf-8
class Node::Node::Nodes
  
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    
    model Node::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Cms::Node.site(@cur_site).node(@cur_node).
        order_by(filename: 1).
        page(params[:page]).per(20)
      
      render
    end
  end
end