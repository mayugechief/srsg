# coding: utf-8
class Cms::Page
  extend ActiveSupport::Autoload

  autoload :Feature
  autoload :Model
  include Model
  
  #scope :my_route, -> { where route: "cms/pages" }
end
