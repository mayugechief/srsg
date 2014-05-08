# coding: utf-8
class Cms::Node
  extend ActiveSupport::Autoload
  autoload :Model
  
  include Cms::Node::Model
  
  class Base
    include Cms::Node::Model
  
    default_scope ->{ where(route: /^cms\//) }
  end
  
  class Node
    include Cms::Node::Model
    include Cms::Addon::NodeList
    
    default_scope ->{ where(route: "cms/node") }
  end
  
  class Page
    include Cms::Node::Model
    include Cms::Addon::PageList
    
    default_scope ->{ where(route: "cms/page") }
  end
  
  class << self
    @@plugins = []
    
    def plugin(path)
      name  = I18n.t("modules.#{path.sub(/\/.*/, '')}", default: path.titleize)
      name << "/" + I18n.t("cms.nodes.#{path.singularize}", default: path.titleize)
      @@plugins << [name, path]
    end
    
    def plugins
      @@plugins
    end
    
    def modules
      keys = @@plugins.map {|m| m[1].sub(/\/.*/, "") }.uniq
      keys.map {|key| [I18n.t("modules.#{key}", default: key.to_s.titleize), key] }
    end
  end
end
