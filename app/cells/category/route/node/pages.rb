# coding: utf-8
module Category::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Category::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Cms::Page.site(@cur_site).
        where(category_ids: @cur_node.id).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Cms::Page.site(@cur_site).
        where(category_ids: @cur_node.id).
        order_by(published: -1).
        limit(20)
      
      render_rss @cur_node, @items
    end
  end
end
