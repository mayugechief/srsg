# coding: utf-8
class Category::Part
  include Cms::Part::Model
  
  class Node
    include Cms::Part::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "category/nodes" }
  end
end
