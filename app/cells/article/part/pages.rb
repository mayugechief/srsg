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
      
      @items = Cms::Page.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(deleted: nil).
        sort(_id: -1)
      
      render
    end
  end
end