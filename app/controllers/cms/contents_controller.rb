# coding: utf-8
class Cms::ContentsController < ApplicationController
  include SS::BaseFilter
  include Cms::BaseFilter
  
  crumb ->{ [:contents, cms_contents_path] }
  
  public
    def index
      @model = Cms::Content
      
      @items = Cms::Content.site_is(@cur_site)
        .ne(route: :article)
        .sort(filename: 1)
    end
end
