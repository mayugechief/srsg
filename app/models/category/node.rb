# coding: utf-8
class Category::Node
  include Cms::Node::Model
  
  scope :my_route, -> { where route: /^category\// }
  
  class Node
    include Cms::Node::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "category/nodes" }
  end
  
  class Page
    include Cms::Node::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "category/pages" }
  end
end
