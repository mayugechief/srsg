# coding: utf-8
module Cms
  class Initializer
    Cms::Part.plugin "cms/frees"
    
    Cms::Page.addon "cms/tiny"
    Cms::Page.addon "cms/wiki"
    Cms::Page.addon "cms/html"
  end
end
