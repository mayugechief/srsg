# coding: utf-8
class Cms::MainController < ApplicationController
  include SS::BaseFilter
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  
  def index
    #
  end
end
