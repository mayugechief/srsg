# coding: utf-8
class Category::Part
  include Cms::Part::Model
  
  class Node
    include Cms::Part::Model
    include Cms::Addons::NodeList
    
    scope :my_route, -> { where route: "category/nodes" }
  end
end
