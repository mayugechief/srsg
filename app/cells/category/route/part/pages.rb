# coding: utf-8
module Category::Route::Part::Pages
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Category::Part::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @cur_node = @cur_part.node
      return "" unless @cur_node
      
      @items = Cms::Page.site(@cur_site).
        where(category_ids: @cur_node.id).
        order_by(@cur_part.orders).
        page(params[:page]).
        per(@cur_part.limit)
      
      render
    end
  end
end
