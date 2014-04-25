# coding: utf-8
class Sns::User::FilesController < ApplicationController
  include Sns::UserFilter
  include Sns::CrudFilter
  include Sns::FileFilter
  
  model SS::UserFile
  
  private
    def set_crumbs
      @crumbs << [:files, sns_user_files_path]
    end
    
    def fix_params
      { user_id: @cur_user.id }
    end
    
  public
    def index
      cond = (@cur_user.id != @sns_user.id) ? { state: :public } : { }
      
      @items = @model.
        where(cond).
        where(user_id: @sns_user.id).
        order_by(_id: -1).
        page(params[:page]).per(20)
    end
end
