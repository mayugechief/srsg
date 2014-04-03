# coding: utf-8
module Category::Route::Node::Nodes
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
      
      @items.empty? ? "" : render
    end
  end
end