# coding: utf-8
class Article::MainController < ApplicationController
  include SS::BaseFilter
  include Cms::BaseFilter
  
  def index
    redirect_to article_pages_path
  end
end
