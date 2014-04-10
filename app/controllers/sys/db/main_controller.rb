# coding: utf-8
class Sys::Db::MainController < ApplicationController
  include Sys::BaseFilter
  
  public
    def index
      redirect_to sys_db_colls_path
    end
end
