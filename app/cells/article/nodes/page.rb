# coding: utf-8
module Article::Nodes::Page
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Article::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @items = Article::Page.site(@cur_site).public.
        where(@cur_node.condition_hash).
        order_by(@cur_node.orders).
        page(params[:page]).
        per(@cur_node.limit)
      
      @items.empty? ? "" : render
    end
    
    def rss
      @items = Article::Page.site(@cur_site).public.
        where(@cur_node.condition_hash).
        order_by(published: -1).
        per(@cur_node.limit)
      
      render_rss @cur_node, @items
    end
  end
end
