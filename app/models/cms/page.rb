# coding: utf-8
class Cms::Page
  extend ActiveSupport::Autoload
  autoload :Feature
  autoload :Model
  include Model
  
  #default_scope ->{ where(route: "cms/pages") }
  
  validates :filename, presence: true
  
  class << self
    def addon(path)
      Article::Page.include path.sub("/", "/addons/").camelize.constantize
      super(path)
    end
  end
end
