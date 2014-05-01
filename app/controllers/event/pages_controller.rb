# coding: utf-8
class Event::PagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter

  model Event::Page

  append_view_path "app/views/cms/pages"
  navi_view "event/main/navi"

  private
    def fix_params
      { cur_user: @cur_user, site_id: @cur_site._id, cur_node: @cur_node }
    end

  public
    def index
      @items = @model.site(@cur_site).node(@cur_node).
        order_by(updated: -1).
        page(params[:page]).per(50)
    end
end
