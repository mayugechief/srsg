# coding: utf-8
class Article::Page
  include Cms::Page::Base
  
  scope :my_route, -> { where route: "article/pages" }
end
