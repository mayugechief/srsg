# coding: utf-8
class Article::ConfigsController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  crumb ->{ [@cur_node.name, article_main_path] }
  crumb ->{ [:configs, article_configs_path] }
  
  navi_view "article/main/navi"
  menu_view false
  
  def index
    #exit
  end
end
