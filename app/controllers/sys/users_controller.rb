# coding: utf-8
class Sys::UsersController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter
  
  model SS::User
  
  navi_view "sys/main/navi"
  
  javascript "ss/groups"
  javascript "jquery.multi-select.js"
  stylesheet "jquery-ui/multi-select/css/multi-select.css"
  
  private
    def set_crumbs
      @crumbs << [:users, sys_users_path]
    end
  
  public
    def index
      @items = @model.all.
        order_by(_id: -1)
    end
end
