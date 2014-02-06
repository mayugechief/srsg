# coding: utf-8
class Article::Node
  include Cms::Node::Base
  
  default_scope where route: "article"
  
  scope :main, where(type: "main")
  scope :item, where(type: "item")
end
