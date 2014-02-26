# coding: utf-8
class Category::Part::Nodes
  
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    
    model Category::Part::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    
    def index
      @cur_node = @cur_page.node
      
      @items = Category::Node.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(deleted: nil).
        sort(_id: -1)
      
      render
    end
  end
end