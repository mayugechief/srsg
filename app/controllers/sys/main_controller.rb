# coding: utf-8
class Sys::MainController < ApplicationController
  include Sys::BaseFilter
  
  navi_view "sys/main/navi"
  
  public
    def index
      #
    end
end
