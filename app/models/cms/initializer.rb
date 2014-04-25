# coding: utf-8
module Cms
  class Initializer
    Cms::Part.plugin "cms/frees"
    Cms::Part.plugin "cms/crumbs"
    
    Cms::Page.addon "cms/meta"
    Cms::Page.addon "cms/body"
    Cms::Page.addon "cms/files"
  end
end
