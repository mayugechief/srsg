# coding: utf-8
module Article::Route::Part::Pages
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Article::Part::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @cur_node = @cur_part.node
      
      @items = Article::Page.site(@cur_site).node(@cur_node).
        where(deleted: nil).
        order_by(@cur_part.orders).
        page(params[:page]).
        per(@cur_part.limit)
      
      @items.empty? ? "" : render
    end
  end
end
