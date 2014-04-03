# coding: utf-8
module Category::Route::Node::Pages
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model Category::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::NodeFilter::ViewCell
    
    def index
      @items = Cms::Page.site(@cur_site).
        where(category_ids: @cur_node.id).
        order_by(_id: -1).
        page(params[:page]).per(20)
      
      @items.empty? ? "" : render
    end
  end
end