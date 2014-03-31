# coding: utf-8
class Uploader::FilesController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  
  model Uploader::File
  
  navi_view "uploader/main/navi"
  
  public
    def index
      @path  = @cur_node.path
      @items = []
      
      return if !::Dir.exists?(@path)
      
      # Find -> Dir.glob
      require 'find'
      Find.find(@path) do |f|
        next if f == @path
        @items << f.sub(@path + "/", "")
      end
    end
    
    def create
      params[:item][:files].each do |file|
        path = "#{@cur_node.path}/#{file.original_filename}"
        Fs.binwrite(path, file.read)
      end
      
      redirect_to action: :index
    end
end
