# coding: utf-8
class Cms::Page
  extend ActiveSupport::Autoload
  autoload :Feature
  autoload :Model
  
  include Model
  
  #default_scope ->{ where(route: "cms/page") }
  
  class << self
    public
      def addon(path)
        Cms::Page::Model.include path.sub("/", "/addon/").camelize.constantize
        super
      end
  end
end
