# coding: utf-8
module Article
  class Initializer
    Cms::Node.plugin "article/page"
    Cms::Part.plugin "article/page"
    
    Article::Page.inherit_addons Cms::Page
  end
end
