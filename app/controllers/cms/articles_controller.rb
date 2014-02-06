# coding: utf-8
class Cms::ArticlesController < ApplicationController
  include SS::BaseFilter
  include Cms::BaseFilter
  
  crumb ->{ [:articles, cms_articles_path] }
  
  navi_view "cms/main/navi"
  menu_view false
  
  public
    def index
      @model = Cms::Content
      
      @items = Cms::Content.site_is(@cur_site)
        .where(route: :article)
        .sort(filename: 1)
    end
end