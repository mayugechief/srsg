# coding: utf-8
class Sys::MainController < ApplicationController
  include SS::BaseFilter
  include Sys::BaseFilter
  
  navi_view "sys/main/navi"
  
  def index
    #
  end
end
