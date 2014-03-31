# coding: utf-8
class Cms::Node
  extend ActiveSupport::Autoload
  
  autoload :Model
  include Model
  
  class << self
    @@plugins = []
    
    def plugin(path)
      name = I18n.translate path.singularize, scope: [:modules, :nodes], default: path.titleize
      @@plugins << [name, path]
    end
    
    def plugins
      @@plugins
    end
    
    def modules
      keys = @@plugins.map {|m| m[1].sub(/\/.*/, "") }.uniq
      keys.map do |key|
        name = I18n.translate key, scope: [:modules, :contents], default: key.to_s.titleize
        [name, key]
      end
    end
  end
end
