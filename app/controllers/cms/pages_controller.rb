# coding: utf-8
class Cms::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Cms::Page
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:pages, action: :index]
    end
    
    def fix_params
      { cur_user: @cur_user, site_id: @cur_site._id, cur_node: false }
    end
    
  public
    def index
      @items = @model.site(@cur_site).
        where(depth: 1).
        where(route: "cms/pages").
        where_permitted(user: @cur_user, site: @cur_site).
        order_by(updated: -1).
        page(params[:page]).per(100)
    end
end
