# coding: utf-8
class Category::Node
  include Cms::Node::Model
  
  scope :my_route, -> { where route: /^category\// }
  
  #TODO:
  Cms::Page.embeds_ids :categories, class_name: "Category::Node"
  Article::Page.embeds_ids :categories, class_name: "Category::Node"
  
  class Node
    include Cms::Node::Model
    
    scope :my_route, -> { where route: "category/nodes" }
    field :limit, type: Integer, default: 20
  end
  
  class Page
    include Cms::Node::Model
    
    scope :my_route, -> { where route: "category/pages" }
    field :limit, type: Integer, default: 20
  end
end
