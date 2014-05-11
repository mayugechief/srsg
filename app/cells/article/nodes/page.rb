# coding: utf-8
module Article::Nodes::Page
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Article::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    helper Cms::ListHelper
    
    public
      def pages
        Article::Page.site(@cur_site).public.
          where(@cur_node.condition_hash)
      end
      
      def index
        @items = pages.
          order_by(@cur_node.orders).
          page(params[:page]).
          per(@cur_node.limit)
        
        @items.empty? ? "" : render
      end
      
      def rss
        @items = pages.
          order_by(released: -1).
          limit(@cur_node.limit)
        
        render_rss @cur_node, @items
      end
  end
end
