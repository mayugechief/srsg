# coding: utf-8
class Fs::FilesController < ApplicationController
  
  public
    def index
      path  = params[:path]
      path << ".#{params[:format]}" if params[:format].present?
      
      @item = SS::Fs.find_by filename: path
      send_data @item.read, type: @item.contentType, filename: @item.filename, disposition: :inline
    end
end
