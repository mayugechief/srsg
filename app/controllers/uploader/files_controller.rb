# coding: utf-8
class Uploader::FilesController < ApplicationController
  include SS::BaseFilter
  include SS::CrudFilter
  include Cms::BaseFilter
  
  model Uploader::File
  
  crumb ->{ [:contents, cms_contents_path] }
  crumb ->{ [@cur_node.name, uploader_main_path] }
  
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
        Storage.binwrite(path, file.read)
      end
      
      redirect_to action: :index
    end
end
