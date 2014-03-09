# coding: utf-8
class Cms::Part
  extend ActiveSupport::Autoload

  autoload :Model
  include Model
  
  class << self
    @@plugins = []
    
    def plugin(mod, name)
      path = "#{mod}/#{name}"
      name = I18n.translate path.singularize, scope: [:modules, :parts], default: path.titleize
      @@plugins << [name, path]
    end
    
    def plugins
      @@plugins
    end
  end
end
