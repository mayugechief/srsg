# coding: utf-8
class Article::MainController < ApplicationController
  include Cms::BaseFilter
  
  public
    def index
      redirect_to article_pages_path
    end
end
