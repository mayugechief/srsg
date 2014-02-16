# coding: utf-8
class Cms::RolesController < ApplicationController
  include Cms::BaseFilter
  
  navi_view "cms/main/navi"
  menu_view false
  
  private
    def set_crumbs
      @crumbs << [:roles, cms_roles_path]
    end
    
  public
    def index
      render text: "", layout: true
    end
end
