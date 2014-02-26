# coding: utf-8
class Category::Node
  include Cms::Node::Base
  
  default_scope where route: /^category\//
  Cms::Page.embeds_ids :categories, class_name: "Category::Node"
  
  class Node
    include Cms::Node::Base
    
    default_scope where route: "category/nodes"
    field :limit, type: Integer, default: 20
  end
  
  class Page
    include Cms::Node::Base
    
    default_scope where route: "category/pages"
    field :limit, type: Integer, default: 20
  end
end
