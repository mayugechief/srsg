# coding: utf-8
module SS::LayoutFilter
  extend ActiveSupport::Concern
  
  included do
    cattr_accessor(:stylesheets) { [] }
    cattr_accessor(:javascripts) { [] }
    cattr_accessor(:crumbs) { [] }
    cattr_accessor(:navi_view_file) { nil }
    cattr_accessor(:menu_view_file) { nil }
  end
  
  module ClassMethods
    
    def stylesheet(path)
      self.stylesheets << path
    end
    
    def javascript(path)
      self.javascripts << path
    end
    
    def crumb(proc)
      self.crumbs << proc 
    end
    
    def navi_view(file)
      self.navi_view_file = file 
    end
    
    def menu_view(file)
      self.menu_view_file = file 
    end
  end
end
