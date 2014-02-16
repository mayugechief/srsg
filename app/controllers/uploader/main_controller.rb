# coding: utf-8
class Uploader::MainController < ApplicationController
  include Cms::BaseFilter
  
  public
    def index
      redirect_to uploader_files_path
    end
end
