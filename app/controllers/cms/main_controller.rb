# coding: utf-8
class Cms::MainController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  
  public
    def index
      redirect_to cms_contents_path
    end
end
