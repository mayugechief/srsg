# coding: utf-8
module Cms::Parts::Crumb
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Cms::Part::Crumb
  end
  
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    
    public
      def index
        @cur_node = @cur_part.node
        
        @root  = @cur_node || @cur_site
        @items = []
        
        if @request_url =~ /^#{@root.url}/
          url = @request_url.sub(/^#{@cur_site.url}/, "").sub(/\/([\w\-]+\.[\w\-]+)?$/, "")
          
          if node = Cms::Node.site(@cur_site).where(filename: url).first
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
