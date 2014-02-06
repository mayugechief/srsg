# coding: utf-8
class Category::Node::Main
  
  class ViewCell < Cell::Rails
    include Cms::PublicFilter
    
    def index
      @items = Cms::Page.site_is(@cur_site)
        .where(:category_ids => @cur_node._id)
        .sort(_id: -1)
      
      render
    end
  end
end