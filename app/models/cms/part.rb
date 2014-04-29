# coding: utf-8
class Cms::Part
  extend ActiveSupport::Autoload
  autoload :Model
  include Model
  
  class Free
    include Cms::Part::Model
    include Cms::Addons::Html
    
    def render_html
      html
    end
  end
  
  class Crumb
    include Cms::Part::Model
    
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
