# coding: utf-8
class Node::Node
  include Cms::Node::Model
  
  class Node
    include Cms::Node::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "node/nodes" }
  end
  
  class Page
    include Cms::Node::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "node/pages" }
  end
end
