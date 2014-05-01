# coding: utf-8
module Cms::Nodes::Page
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Cms::Node::Page
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
        order_by(publushed: -1).
        per(@cur_node.limit)
      
      render_rss @cur_node, @items
    end
  end
end
