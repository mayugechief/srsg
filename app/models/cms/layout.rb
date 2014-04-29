# coding: utf-8
class Cms::Layout
  extend ActiveSupport::Autoload
  autoload :Model
  include Model
  include Cms::Addons::Html
end
