# coding: utf-8
class Cms::PreviewController < Cms::PublicController
  include Cms::BaseFilter
  include Cms::PublicFilter
  
  after_action :render_preview
  
  layout "cms/page"
  
  private
    def set_path
      @path = request.env["REQUEST_PATH"].sub(/^#{cms_preview_path}/, "")
      @path = "index.html" if @path.blank?
      @path = @path.sub(/\/$/, "/index.html").sub(/^\//, "")
      @file = File.join @cur_site.path, @path
    end
    
    def render_preview
      body = combine_layout response.body
      body = replace_preview_paths body
      response.body = body
    end
end
