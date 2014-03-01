# coding: utf-8
class Article::Node
  include Cms::Node::Base
  
  scope :my_route, -> { where route: /^article\// }
  
  class Page
    include Cms::Node::Base
    
    scope :my_route, -> { where route: "article/pages" }
    field :limit, type: Integer, default: 20
  end
end
