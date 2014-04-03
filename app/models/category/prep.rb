# coding: utf-8
module Category
  class Prep
    Cms::Node.plugin "category/nodes"
    Cms::Node.plugin "category/pages"
    Cms::Part.plugin "category/nodes"
    
    Cms::Page.addon "category/categories"
  end
end
