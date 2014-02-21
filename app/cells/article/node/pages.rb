# coding: utf-8
class Article::Node::Pages
  
  class ConfigCell < Cell::Rails
    include Cms::NodeFilter::Config
    
    model Article::Node::Page
  end
  
  class ViewCell < Cell::Rails
    include Cms::PublicFilter
    
    def index
      @items = Cms::Page.site_is(@cur_site).
        where(filename: /^#{@cur_node.filename}\//).
        where(deleted: nil).
        sort(_id: -1)
      render
    end
  end
end