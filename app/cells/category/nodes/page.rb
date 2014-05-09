# coding: utf-8
module Category::Nodes::Page
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Category::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Cms::Page.site(@cur_site).public.
        where(@cur_node.condition_hash).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Cms::Page.site(@cur_site).public.
        where(@cur_node.condition_hash).
        order_by(released: -1).
        limit(@cur_node.limit)
      
      render_rss @cur_node, @items
    end
  end
end
