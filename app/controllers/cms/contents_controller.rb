# coding: utf-8
class Cms::ContentsController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  menu_view false
  
  private
    def set_crumbs
      @crumbs << [:contents, cms_contents_path]
    end
    
  public
    def index
      @model = Cms::Node
      
      @items = Cms::Node.site_is(@cur_site).
        where(shortcut: 1).
        sort(filename: 1)
    end
end
