# coding: utf-8
class Sys::UsersController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter
  
  model SS::User
  
  navi_view "sys/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:users, sys_users_path]
    end
  
  public
    def index
      @items = @model.all
      render_crud
    end
end
