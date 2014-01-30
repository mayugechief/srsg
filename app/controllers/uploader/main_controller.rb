# coding: utf-8
class Uploader::MainController < ApplicationController
  include SS::BaseFilter
  include Cms::BaseFilter
  
  def index
    redirect_to uploader_files_path
  end
end
