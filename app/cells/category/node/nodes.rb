# coding: utf-8
class Category::Node::Nodes
  
  class ViewCell < Cell::Rails
    include Cms::PublicFilter
    
    def index
      @items = @cur_node.children.
        where(route: /^category\//).
        sort(name: 1)
      
      render
    end
  end
end