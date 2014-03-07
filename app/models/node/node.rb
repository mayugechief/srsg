# coding: utf-8
class Node::Node
  include Cms::Node::Model
  
  class Node
    include Cms::Node::Model
    
    scope :my_route, -> { where route: "node/nodes" }
    field :limit, type: Integer, default: 20
  end
  
  class Page
    include Cms::Node::Model
    
    scope :my_route, -> { where route: "node/pages" }
    field :limit, type: Integer, default: 20
  end
end
