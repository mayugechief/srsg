# coding: utf-8
class Cms::PartsController < ApplicationController
  include Cms::BaseFilter
  include Cms::PartFilter
  
  model Cms::Part
  
  navi_view "cms/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:parts, action: :index]
    end
    
    def fix_params
      { site_id: @cur_site._id, cur_node: false }
    end
    
    def pre_params
      { route: "cms/frees" }
    end
    
  public
    def index
      @items = @model.site(@cur_site).
        where(depth: 1).
        where_permitted(user: @cur_user, site: @cur_site).
        order_by(filename: 1).
        page(params[:page]).per(100)
    end
end
