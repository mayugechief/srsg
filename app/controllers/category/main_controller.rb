# coding: utf-8
class Category::MainController < ApplicationController
  #include Cms::BaseFilter
  
  public
    def index
      redirect_to category_nodes_path
    end
end
