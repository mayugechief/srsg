# coding: utf-8
module Category
  class Initializer
    Cms::Node.plugin "category/nodes"
    Cms::Node.plugin "category/pages"
    Cms::Part.plugin "category/nodes"
    Cms::Part.plugin "category/pages"
    
    Cms::Page.addon "category/categories"
  end
end
