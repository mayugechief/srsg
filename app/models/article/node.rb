# coding: utf-8
class Article::Node
  include Cms::Node::Model
  
  scope :my_route, -> { where route: /^article\// }
  
  class Page
    include Cms::Node::Model
    include Cms::Addons::PageList
    
    scope :my_route, -> { where route: "article/pages" }
  end
end
