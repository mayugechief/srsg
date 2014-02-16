# coding: utf-8
class Cms::ArticlesController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  menu_view false
  
  private
    def set_crumbs
      @crumbs << [:articles, cms_articles_path]
    end
    
  public
    def index
      @model = Cms::Node
      
      @items = Cms::Node.site_is(@cur_site).
        where(route: "article/pages").
        where(shortcut: 1).
        sort(filename: 1)
    end
end