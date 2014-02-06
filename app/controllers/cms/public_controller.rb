# coding: utf-8
class Cms::PublicController < ApplicationController
  
  #before_action :dev_site, if: -> { Rails.env.to_s == "development" }
  before_action :set_site
  before_action :set_path
  before_action :redirect_slash, if: ->{ request.env["REQUEST_PATH"] =~ /\/[^\.]+[^\/]$/ }
  before_action :x_sendfile
  before_action :check_mobile
  before_action :check_kana
  before_action :render_scss
  before_action :render_piece
  before_action :render_layout
  after_action :render_mobile
  
  layout 'cms/public'
    
  public
    def index
      render_page
      render_node if response.body.blank?
      
      respond_to do |format|
        format.html { response.headers['Content-Type'] ||= "text/html; charset=utf-8" }
        format.json { response.headers['Content-Type'] ||= "application/json; charset=utf-8" }
      end
      
      render :nothing => true, :status => 404 if response.body.blank?
    end
  
  private
    def dev_site
      @cur_site ||= SS::Site.first if request.env["HTTP_HOST"] =~ /^[\d\.:]+$/
    end
    
    def set_site
      @cur_site ||= SS::Site.find_by domain: request.env["HTTP_HOST"] rescue nil
      render :nothing => true, :status => 404 if !@cur_site
    end
    
    def set_path
      @path = request.env["REQUEST_PATH"].sub(/\/$/, "/index.html").sub(/^\//, "")
      @file = File.join @cur_site.path, @path
    end
    
    def redirect_slash
      redirect_to "#{request.env["REQUEST_PATH"]}/"
    end
    
    def x_sendfile
      send_file @file, disposition: :inline, x_sendfile: true if Storage.exists? @file
    end
    
    def  render_scss
      return if @path !~ /\.css$/
      
      file = @file.sub(/\.css$/, ".scss")
      return render :nothing => true, :status => 404 unless Storage.exists?(file)
      
      #dirs = [File.dirname(file)]
      
      sass = Sass::Engine.new Storage.read(file), filename: file, syntax: :scss, cache: false,
        load_paths: Compass.configuration.sass_load_paths,
        debug_info: Srsg::Application.config.sass.debug_info
      
      #sass.for_file file
      response.headers['Content-Type'] ||= 'text/css; charset=utf-8'
      render inline: sass.render
    end
    
    def recognize_path(path)
      rec = Rails.application.routes.recognize_path(path, method: request.method) rescue {}
      rec[:cell] ? { controller: rec[:cell], action: rec[:action] } : nil
    end
    
    def render_piece
      return if @path !~ /\.piece\.(html|json)$/
      
      path = @path.sub(/\.json$/, ".html")
      page = Cms::Piece.find_by(site_id: @cur_site, filename: path) rescue nil
      return render :nothing => true, :status => 404 unless page
      
      if page.route.present?
        cell = recognize_path "/.#{@cur_site.host}/piece/#{page.route}.#{@path.sub(/.*\./, '')}"
        return render :nothing => true, :status => 404 unless cell
        params.merge! cur_site: @cur_site, cur_page: page
        body = render_cell "#{page.route.sub('/', '/piece/')}/view", cell[:action]
      else
        body = page.html
      end
      
      body = render_kana body
      
      respond_to do |format|
        format.html do
          html = "<!doctype html><html><body>#{html}</body></html>"
          render inline: body
        end
        format.json do
          body.gsub!(/^<header>.*?<\/header>/m, "")
          body.gsub!(/^<nav>.*?<\/nav>/m, "")
          body.gsub!(/^<footer>.*?<\/footer>/m, "")
          render json: body.to_json
        end
      end
    end
    
    def render_layout
      return if @path !~ /\.layout\.(html|json)$/
      
      path = @path.sub(/\.json$/, ".html")
      page = Cms::Layout.find_by(site_id: @cur_site, filename: path) rescue nil
      return render :nothing => true, :status => 404 unless page
      
      body = render_kana(page.render_html)
      
      respond_to do |format|
        format.html { render inline: body }
        format.json { render json: page.render_json(body) }
      end
    end
    
    def render_page
      page = Cms::Page.find_by(site_id: @cur_site, filename: @path) rescue nil 
      return unless page
      
      params.merge! cur_site: @cur_site, cur_page: page
      body = render_cell "cms/editor/page/view", "index"
      
      body = render_kana body
      
      @cur_page   = page
      @cur_layout = page.layout
      
      respond_to do |format|
        format.html { render inline: body, layout: true }
        format.json { render json: body.to_json }
      end
    end
    
    def render_node
      dirs  = []
      names = @path.sub(/\/[^\/]+$/, "").split('/')
      names.each {|name| dirs << (dirs.size == 0 ? name : "#{dirs.last}/#{name}") }
      
      node = Cms::Node.where(site_id: @cur_site.id, :filename.in => dirs).sort(depth: -1).first
      return unless node
      
      rest = @path.sub(/^#{node.filename}/, "")
      cell = recognize_path "/.#{@cur_site.host}/node/#{node.route}/#{node.type}#{rest}"
      return unless cell
      
      params.merge! cur_site: @cur_site, cur_node: node
      body = render_cell "#{node.route}/node/#{node.type}/view", cell[:action]
      
      body = render_kana body
      
      @cur_node   = node
      @cur_layout = node.layout
      
      respond_to do |format|
        format.html { render inline: body, layout: true }
        format.json { render json: body.to_json }
      end
    end
    
    def check_mobile
      return if request.env["REQUEST_PATH"] !~ /\/[\w\-]+\.mobile\.html$/
      @path = @path.sub(/\.mobile\.html$/, ".html")
    end
    
    def render_mobile
      return if request.env["REQUEST_PATH"] !~ /\/[\w\-]+\.mobile\.html$/
      return if response.status != 200
      
      body = response.body
      response.body = nil
      
      head = body.match(/<header.*?<\/header>/m)
      body = body.sub(/.*?<article>.*?<\/script>(.*)<\/div>.*/m, '\\1')
      
      body = @cur_layout.render_html.sub!(/<\/ yield \/>/, body) if @cur_layout
      
      body.gsub!(/<(\/?)(header|nav|footer)( |>)/, '<\\1div\\3')
      body.gsub!(/<link[ >].*?\/>/, "")
      body.gsub!(/<script[ >].*?<\/script>/, "")
      body.gsub!(/<body/, '<body style="font-size: 80%;"')
      body.gsub!(/<(h\d)(.*?)>/, '<div\\2 class="\\1">\\1: ')
      body.gsub!(/<\/(h\d)>/, '</div>')
      body.gsub!(/( *\n+ *)+/, "\n")
      
      response.body = body
    end
    
    def check_kana
      return if request.env["REQUEST_PATH"] !~ /\/[\w\-]+(\.\w+)?\.kana\.(html|json)$/
      @path = @path.sub(/\.kana\.(html|json)$/, ".html")
    end
    
    def render_kana(body)
      return body if request.env["REQUEST_PATH"] !~ /\/[\w\-]+(\.\w+)?\.kana\.(html|json)/
      body = Cms::Kana.kana_html(body).strip
    end
end