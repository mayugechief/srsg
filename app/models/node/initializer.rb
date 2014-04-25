# coding: utf-8
module Node
  class Initializer
    Cms::Node.plugin "node/nodes"
    Cms::Node.plugin "node/pages"
    Cms::Part.plugin "node/nodes"
    Cms::Part.plugin "node/pages"
  end
end
