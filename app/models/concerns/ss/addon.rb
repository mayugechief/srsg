# coding: utf-8
module SS::Addon
  module Model
    def included(mod)
      extend ActiveSupport::Concern
      extend SS::Translation
      extend ClassMethods
    end
    
    module ClassMethods
      def addon_name
        SS::Addon::Name.new(self)
      end
    end
  end
  
  class Name
    def initialize(name, params = {})
      @class = name
      @name  = name.is_a?(String) ? name : name.to_s.underscore.sub("addon/", "")
    end
    
    def name
      I18n.t @name, scope: [:modules, :addons], default: @name.titleize
    end
    
    def path
      @name.sub("/", "/addons/")#.pluralize
    end
    
    def exists?(type = :view)
      begin
        klass = "#{path}/#{type}_cell".camelize
        klass = Module.const_get(klass)
        klass.is_a?(Class)
      rescue
        return false
      end
    end
  end
end
