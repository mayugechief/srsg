# coding: utf-8
class Category::Part
  include Cms::Part::Base
  
  default_scope where route: /^category\//
  
  class Node
    include Cms::Part::Base
    
    default_scope where route: "category/nodes"
    field :limit, type: Integer, default: 20
  end
end
