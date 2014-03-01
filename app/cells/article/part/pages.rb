# coding: utf-8
class Article::Part::Pages
  
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    
    model Article::Part::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    
    def index
      @cur_node = @cur_page.node
      
      @items = Article::Page.site(@cur_site).node(@cur_node).my_route.
        where(deleted: nil).
        order_by(_id: -1).
        page(params[:page]).per(20)
      
      render
    end
  end
end