# coding: utf-8
class Category::MainController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  def index
    redirect_to category_nodes_path
  end
end
