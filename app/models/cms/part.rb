# coding: utf-8
class Cms::Part
  extend ActiveSupport::Autoload

  autoload :Model
  include Model
  
  class Free
    include Cms::Part::Model
    
    def render_html
      html
    end
  end
  
  class Crumb
    include Cms::Part::Model
  end
  
  class << self
    @@plugins = []
    
    def plugin(path)
      name = I18n.translate path.singularize, scope: [:modules, :parts], default: path.titleize
      @@plugins << [name, path]
    end
    
    def plugins
      @@plugins
    end
  end
end
