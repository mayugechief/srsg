# coding: utf-8
class SS::Addon::Name
  def initialize(name, params = {})
    @class = name
    @name  = name.is_a?(String) ? name : name.to_s.underscore.sub("addons/", "")
  end
  
  def name
    I18n.t @name, scope: [:modules, :addons], default: @name.titleize
  end
  
  def path
    @name.sub("/", "/addon/")#.pluralize
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
