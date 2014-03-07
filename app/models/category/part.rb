# coding: utf-8
class Category::Part
  include Cms::Part::Model
  
  class Node
    include Cms::Part::Model
    
    scope :my_route, -> { where route: "category/nodes" }
    field :limit, type: Integer, default: 20
  end
end
