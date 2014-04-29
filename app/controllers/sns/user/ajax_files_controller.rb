# coding: utf-8
class Sns::User::AjaxFilesController < ApplicationController
  include Sns::UserFilter
  include Sns::CrudFilter
  include Sns::FileFilter
  include SS::AjaxFilter
  
  model SS::UserFile
    
  private
    def fix_params
      { user_id: @cur_user.id }
    end
    
  public
    def index
      cond = (@cur_user.id != @sns_user.id) ? { state: :public } : { }
      
      @items = @model.
        where(cond).
        where(user_id: @cur_user.id).
        order_by(_id: -1).
        page(params[:page]).per(20)
    end
    
    def select
      set_item
      
      item = SS::TempFile.new
      
      @item.attributes.each do |key, val|
        next if key =~ /^(id|file_id)$/
        item.send("#{key}=", val) unless item.send(key)
      end
      
      item.state   = "public"
      item.in_file = @item.uploaded_file
      item.save
      @item = item
      
      render layout: !request.xhr?
    end
end
