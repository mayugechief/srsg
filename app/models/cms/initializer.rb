# coding: utf-8
module Cms
  class Initializer
    Cms::Node.plugin "cms/node"
    Cms::Node.plugin "cms/page"
    
    Cms::Part.plugin "cms/free"
    Cms::Part.plugin "cms/node"
    Cms::Part.plugin "cms/page"
    Cms::Part.plugin "cms/crumb"
    
    Cms::Page.addon "cms/meta"
    Cms::Page.addon "cms/body"
    Cms::Page.addon "cms/file"
  end
end
