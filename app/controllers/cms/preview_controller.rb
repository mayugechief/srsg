# coding: utf-8
class Cms::PreviewController < ApplicationController
  include Cms::BaseFilter
  include Cms::PublicFilter
  
  before_action :set_path_with_preview, prepend: true
  after_action :render_preview
  
  private
    def set_site
      @cur_site    = SS::Site.find_by host: params[:host]
      @preview     = true
    end
    
    def set_path_with_preview
      @path ||= request.env["REQUEST_PATH"]
      @path = @path.sub(/^#{cms_preview_path}/, "")
      @path = "index.html" if @path.blank?
    end
    
    def x_sendfile(file = @file)
      return if file =~ /\.html$/
      raise "404" unless Fs.exists?(file)
      super
    end
    
    def render_preview
      body = response.body
      
      body = embed_layout(body, @cur_layout) if @cur_layout
      
      body.gsub!(/(href|src)=".*?"/) do |m|
        url = m.match(/.*?="(.*?)"/)[1]
        if url =~ /^\/(assets|images|javascripts|stylesheets)\//
          m
        elsif url =~ /^\//
          m.sub(/="/, "=\"#{cms_preview_path}")
        else
          m
        end
      end
      
      css  = "position: fixed; top: 0px; left: 0px; padding: 5px;"
      css << "background-color: rgba(0, 150, 100, 0.6); color: #fff; font-weight: bold;"
      mark = %Q[<div id="ss-preview" style="#{css}">Preview</div>]
      body.sub!("</body>", "#{mark}</body>")
      
      response.body = body
    end
end
