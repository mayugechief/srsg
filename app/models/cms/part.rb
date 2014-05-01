# coding: utf-8
class Cms::Part
  extend ActiveSupport::Autoload
  autoload :Model
  
  include Cms::Part::Model
  
  class Base
    include Cms::Part::Model
  
    default_scope ->{ where(route: /^cms\//) }
  end
  
  class Free
    include Cms::Part::Model
    include Cms::Addon::Html
    
    default_scope ->{ where(route: "cms/free") }
    
    def render_html
      html
    end
  end
  
  class Node
    include Cms::Part::Model
    include Cms::Addon::NodeList
    
    default_scope ->{ where(route: "cms/node") }
  end
  
  class Page
    include Cms::Part::Model
    include Cms::Addon::PageList
    
    default_scope ->{ where(route: "cms/page") }
  end
  
  class Crumb
    include Cms::Part::Model
    
    default_scope ->{ where(route: "cms/crumb") }
    
    field :home_label, type: String
    permit_params :home_label
    
    def home_label
      read_attribute(:home_label).presence || "HOME"
    end
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
