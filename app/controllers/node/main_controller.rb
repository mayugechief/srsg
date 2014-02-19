# coding: utf-8
class Node::MainController < ApplicationController
  include Cms::BaseFilter
  
  public
    def index
      redirect_to node_pages_path
    end
end
