# coding: utf-8
module Cms::Route::Part::Crumbs
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Cms::Part::Crumb
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    
    def index
      @cur_node = @cur_page.node
      
      @root  = @cur_node || @cur_site
      @items = []
      
      if params[:ref] =~ /^#{@root.url}/
        ref = params[:ref].sub(/^#{@cur_site.url}/, "").sub(/\/([\w\-]+\.[\w\-]+)?$/, "")
        
        if node = Cms::Node.site(@cur_site).where(filename: ref).first
          @items.unshift [node.name, node.url]
          while parent = node.parent
            break if @cur_node && @cur_node.id == parent.id
            @items.unshift [parent.name, parent.url]
            node = parent
          end
        end
      end
      
      @items.unshift [@root.name, @root.url]
      
      @items.empty? ? "" : render
    end
  end
end
