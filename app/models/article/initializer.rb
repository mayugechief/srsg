# coding: utf-8
module Article
  class Initializer
    Cms::Node.plugin "article/pages"
    Cms::Part.plugin "article/pages"
  end
end
