# coding: utf-8
class Acl::EntriesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Acl::Entry
  
  navi_view "acl/main/navi"
  
  javascript "acl/form-select-group"
  
  private
    def set_crumbs
      @crumbs << [:entries, acl_entries_path]
    end
    
    def fix_params
      { site_id: @cur_site._id }
    end    
    
  public
    def index
      @items = @model.site(@cur_site).
        order_by(_id: -1)
    end

    def select_group_users
      @users = SS::User.all.
        where( group_ids: params[:select_group_id].to_i).
        order_by(_id: -1)
        render
    end
end
