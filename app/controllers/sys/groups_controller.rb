# coding: utf-8
class Sys::GroupsController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter
  
  model SS::Group
  
  navi_view "sys/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:groups, sys_groups_path]
    end
  
  public
    def index
      @items = @model.all.
        order_by(name: 1)
    end
end
