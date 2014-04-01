# coding: utf-8
class Cms::PreviewController < ApplicationController
  include Cms::BaseFilter
  include Cms::PublicController::Filter
  
  after_action :render_preview, prepend: true
  
  private
    def set_path
      @path = request.env["REQUEST_PATH"].sub(/^#{cms_preview_path}/, "")
      @path = "index.html" if @path.blank?
      @path = @path.sub(/\/$/, "/index.html").sub(/^\//, "")
      @file = File.join @cur_site.path, @path
    end
    
    def render_preview
      body = response.body
      body = combine_layout body unless @mobile
      body = replace_preview_paths body
      response.body = body
    end
end