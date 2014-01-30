# coding: utf-8
class Article::ConfigsController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  crumb ->{ [:articles, cms_articles_path] }
  crumb ->{ [@cur_node.name, article_main_path] }
  crumb ->{ [:configs, article_configs_path] }
  
  def index
    #exit
  end
end
