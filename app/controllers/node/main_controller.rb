# coding: utf-8
class Node::MainController < ApplicationController
  include Cms::BaseFilter
  
  public
    def index
      redirect_to node_nodes_path
    end
end
