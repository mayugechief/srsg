# coding: utf-8
module Node::Route::Part::Pages
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Category::Part::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @cur_node = @cur_part.node
      
      if @cur_node
        cond =  { filename: /^#{@cur_node.filename}\//, depth: @cur_node.depth + 1 }
      else
        cond =  { depth: 1 }
      end
      
      @items = Cms::Page.site(@cur_site).
        where(cond).
        order_by(@cur_part.orders).
        page(params[:page]).
        per(@cur_part.limit)
      
      render
    end
  end
end
