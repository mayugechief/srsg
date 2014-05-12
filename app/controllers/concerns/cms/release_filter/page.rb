# coding: utf-8
module Cms::ReleaseFilter::Page
  extend ActiveSupport::Concern
  include Cms::ReleaseFilter
  
  private
    def find_page(path)
      page = Cms::Page.find_by(site_id: @cur_site, filename: path) rescue nil
      return unless page
      @preview || page.public? ? page : nil
    end
    
    def render_page(page, env = {})
      cell = recognize_path "/.#{@cur_site.host}/pages/#{page.route}/#{page.basename}", env
      return unless cell
      
      @cur_page   = page
      @cur_layout = page.layout
      render_cell page.route.sub(/\/.*/, "/#{cell[:controller]}/view"), cell[:action]
    end
    
    def send_page(body)
      return unless body
      respond_to do |format|
        format.html { render inline: body, layout: "cms/page" }
        format.json { render json: body }
        format.xml  { render xml: body }
      end
    end
    
    def generate_page(page)
      self.params = ActionController::Parameters.new format: "html"
      self.request = ActionDispatch::Request.new method: "GET"
      self.response = ActionDispatch::Response.new
      
      body = render_page(page, method: "get")
      html = render_to_string inline: body, layout: "cms/page"
      
      keep = html.to_s == File.read(page.path).to_s rescue false # prob: csrf-token
      
      Fs.write page.path, html unless keep
    end
end
