# coding: utf-8
module Article
  class Initializer
    Cms::Node.plugin "article/page"
    Cms::Part.plugin "article/page"
  end
end
