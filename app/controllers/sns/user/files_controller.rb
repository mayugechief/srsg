# coding: utf-8
class Sns::User::FilesController < ApplicationController
  include Sns::BaseFilter
  include Sns::CrudFilter
  
  model Sns::UserFile
  
  navi_view "sns/main/navi"
  
  private
    def set_crumbs
      @crumbs << [:files, sns_files_path]
    end
  
    def fix_params
      super.merge({ cur_user: @cur_user })
    end
    
  public
    def index
      @items = @model.my_model.
        where(user_id: @cur_user.id).
        order_by(_id: -1).
        page(params[:page]).per(20)
    end
    
    def view
      set_item
      send_data @item.read, type: @item.contentType, filename: @item.filename,
        disposition: :inline
    end
    
    def download
      set_item
      send_data @item.read, type: @item.contentType, filename: @item.filename,
        disposition: :attachment
    end
    
    def thumb
      set_item
      
      require 'RMagick'
      image = Magick::Image.from_blob(@item.read).shift
      image = image.resize_to_fit 120, 90 if image.columns > 120 || image.rows > 90
      
      send_data image.to_blob, type: @item.contentType, filename: @item.filename, disposition: :inline
    rescue
      raise "500"
    end
    
    def create
      @item = @model.new get_params
      @item.files = params[:item][:files]
      render_create @item.save_with_files, location: { action: :index }
    end
end
