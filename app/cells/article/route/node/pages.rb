# coding: utf-8
module Article::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Article::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(published: -1).
        limit(20)
      
      render_rss @cur_node, @items
    end
  end
end
