# coding: utf-8
class Node::Node
  include Cms::Node::Model
  
  class Node
    include Cms::Node::Model
    include Cms::Addons::NodeList
    
    scope :my_route, -> { where route: "node/nodes" }
  end
  
  class Page
    include Cms::Node::Model
    include Cms::Addons::PageList
    
    scope :my_route, -> { where route: "node/pages" }
  end
end
