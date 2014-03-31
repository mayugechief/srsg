# coding: utf-8
class Cms::Page
  extend ActiveSupport::Autoload

  autoload :Feature
  autoload :Model
  include Model
  
  #scope :my_route, -> { where route: "cms/pages" }
  
  class << self
    def addon(path)
      Article::Page.include path.sub("/", "/addons/").camelize.constantize
      super(path)
    end
  end
end
