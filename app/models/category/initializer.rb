# coding: utf-8
module Category
  class Initializer
    Cms::Node.plugin "category/node"
    Cms::Node.plugin "category/page"
    Cms::Part.plugin "category/node"
    
    Cms::Page.addon "category/category"
  end
end
