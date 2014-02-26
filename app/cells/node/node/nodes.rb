# coding: utf-8
class Node::Node::Nodes
  
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    
    model Node::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Cms::Node.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        order_by(filename: 1).
        page(params[:page]).
        per(20)
      
      render
    end
  end
end