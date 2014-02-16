# coding: utf-8
class Node::RolesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  navi_view "node/main/navi"
  menu_view false
  
  public
    def index
      render text: "", layout: true
    end
end
