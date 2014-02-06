# coding: utf-8
class Sys::TestController < ApplicationController
  include SS::BaseFilter
  include Sys::BaseFilter
  
  crumb ->{ [:http_test, sys_test_path] }
  
  def index
    #
  end
end
