# coding: utf-8
module Category::Route::Part::Nodes
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Category::Part::Node
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    helper Cms::ListHelper
    
    def index
      @cur_node = @cur_page.node
      
      path = params[:ref].present? ? params[:ref].sub(/^\//, "").sub(/\/[^\/]*$/, "") : nil
      node = path ? Category::Node.site(@cur_site).my_route.where(filename: path).first : nil
      node ||= @cur_node
      
      if node && node.dirname
        cond = { filename: /^#{node.dirname}\//, depth: node.depth }
      elsif node
        cond = { filename: /^#{node.filename}\//, depth: node.depth + 1 }
      else
        cond = { depth: 1 }
      end
      
      @items = Category::Node.site(@cur_site).my_route.
        where(cond).
        where(deleted: nil).
        order_by(@cur_page.orders).
        page(params[:page]).
        per(@cur_page.limit)
      
      render
    end
  end
end
