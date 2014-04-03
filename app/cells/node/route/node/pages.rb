# coding: utf-8
module Node::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Node::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        order_by(_id: -1).
        page(params[:page]).per(20)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Cms::Page.site(@cur_site).node(@cur_node).
        order_by(_id: -1).
        limit(20)
      
      render_rss @cur_node, @items
    end
  end
end