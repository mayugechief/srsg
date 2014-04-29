# coding: utf-8
class Sns::User::TempFilesController < ApplicationController
  include Sns::UserFilter
  include Sns::CrudFilter
  include Sns::FileFilter
  include SS::AjaxFilter
  
  model SS::TempFile
  
  private
    def fix_params
      { user_id: @cur_user.id }
    end
  
  public
    def index
      @items = @model.
        where(user_id: @cur_user.id).
        order_by(_id: -1).
        page(params[:page]).per(20)
    end
    
    def select
      set_item
      render layout: !request.xhr?
    end
end
