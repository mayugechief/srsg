# coding: utf-8
class Sys::UsersController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Sys::BaseFilter
  
  model SS::User
  
  public
    def index
      @items = @model.all
      render_crud
    end
end
