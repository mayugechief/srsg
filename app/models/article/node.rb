# coding: utf-8
class Article::Node
  include Cms::Node::Base
  
  default_scope where route: /^article\//
  
  class Page
    include Cms::Node::Base
    
    field :limit, type: Integer, default: 20
  end
end
