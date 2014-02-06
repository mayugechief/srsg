# coding: utf-8
class Sys::GroupsController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Sys::BaseFilter
  
  model SS::Group
  
  crumb ->{ [:groups, sys_groups_path] }
  
  navi_view "sys/main/navi"
  
  public
    def index
      @items = @model.all.sort(name: 1)
      render_crud
    end
end
