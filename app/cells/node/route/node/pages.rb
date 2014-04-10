# coding: utf-8
module Node::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Node::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        order_by(publushed: -1).
        limit(20)
      
      render_rss @cur_node, @items
    end
  end
end
