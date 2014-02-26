# coding: utf-8
class Cms::Page::Page
  
  class ViewCell < Cell::Rails
    include Cms::PageFilter::ViewCell
    
    def index
      render
    end
  end
end