# coding: utf-8
class Category::Part
  include Cms::Part::Base
  
  class Node
    include Cms::Part::Base
    
    scope :my_route, -> { where route: "category/nodes" }
    field :limit, type: Integer, default: 20
  end
end
