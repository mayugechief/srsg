# coding: utf-8
module Article
  class Initializer
    Cms::Node.plugin "article/page"
    Cms::Part.plugin "article/page"
  end
end

class Cms::Page
  _addons = Article::Page.addons.map {|m| m.klass }
  addons.each {|addon| Article::Page.include(addon.klass) unless _addons.include?(addon.klass) }
  
  class << self
    def addon(*args)
      Article::Page.addon *args
      super
    end
  end
end
