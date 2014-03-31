# coding: utf-8
class Article::Node
  include Cms::Node::Model
  
  scope :my_route, -> { where route: /^article\// }
  
  class Page
    include Cms::Node::Model
    
    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "article/pages" }
  end
end
