# coding: utf-8
module Cms::Route::Part::Crumbs
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Cms::Part::Crumb
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    
    def index
      @cur_node = @cur_part.node
      
      @root  = @cur_node || @cur_site
      @items = []
      
      if @ref =~ /^#{@root.url}/
        ref = @ref.sub(/^#{@cur_site.url}/, "").sub(/\/([\w\-]+\.[\w\-]+)?$/, "")
        
        if node = Cms::Node.site(@cur_site).where(filename: ref).first
          @items.unshift [node.name, node.url]
          while parent = node.parent
            break if @cur_node && @cur_node.id == parent.id
            @items.unshift [parent.name, parent.url]
            node = parent
          end
        end
      end
      
      @items.unshift [@cur_part.home_label, @root.url]
      
      @items.empty? ? "" : render
    end
  end
end
