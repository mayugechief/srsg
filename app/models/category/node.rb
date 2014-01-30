# coding: utf-8
class Category::Node
  include Cms::Node::Base
  
  default_scope where route: "category"
  
  scope :root, where(type: "root")
  scope :item, where(type: "item")
  
  Cms::Page.embeds_ids :categories, class_name: "Category::Node"
end
