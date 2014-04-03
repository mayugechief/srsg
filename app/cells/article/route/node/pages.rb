# coding: utf-8
module Article::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Article::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(_id: -1).
        page(params[:page]).per(20)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(_id: -1).
        limit(20)
      
      render_rss @cur_node, @items
    end
  end
end