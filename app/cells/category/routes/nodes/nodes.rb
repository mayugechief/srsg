# coding: utf-8
module Category::Routes::Nodes::Nodes
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    
    model Category::Node::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Category::Node.site(@cur_site).node(@cur_node).my_route.
        order_by(filename: 1).
        page(params[:page]).per(20)
      
      render
    end
  end
end