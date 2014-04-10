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
      @cur_node = @cur_page.node
      
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(@cur_page.orders).
        page(params[:page]).
        per(@cur_page.limit)
      
      @items.empty? ? "" : render
    end
  end
end
