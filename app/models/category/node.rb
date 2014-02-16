# coding: utf-8
class Category::Node
  include Cms::Node::Base
  
  default_scope where route: /^category\//
  
  Cms::Page.embeds_ids :categories, class_name: "Category::Node"
end
