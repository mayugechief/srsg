# coding: utf-8
class Cms::PublicController < ApplicationController
  
  rescue_from StandardError, with: :rescue_action
  
  before_action :deny_requesta
  before_action :dev_site, if: -> { Rails.env.development? }
  before_action :set_site
  before_action :set_path
  before_action :redirect_slash, if: ->{ request.env["REQUEST_PATH"] =~ /\/[^\.]+[^\/]$/ }
  before_action :compile_scss
  before_action :x_sendfile
  before_action :check_mobile
  before_action :check_kana
  before_action :render_part
  before_action :render_layout
  after_action :render_mobile
  
  layout "cms/page"
  
  public
    def index
      render_page
      render_node if response.body.blank?
      
      respond_to do |format|
        format.html { response.headers["Content-Type"] ||= "text/html; charset=utf-8" }
        format.json { response.headers["Content-Type"] ||= "application/json; charset=utf-8" }
      end
      
      raise "404" if response.body.blank?
    end
  
  private
    def deny_requesta
      raise "404" if request.env["REQUEST_PATH"].to_s =~ /^\/sites\/.\//
    end
    
    def dev_site
      @cur_site ||= SS::Site.find_by domains: request.env["HTTP_HOST"] rescue nil
      @cur_site ||= SS::Site.first
    end
    
    def set_site
      @cur_site ||= SS::Site.find_by domains: request.env["HTTP_HOST"] rescue nil
      raise "404" if !@cur_site
    end
    
    def set_path
      @path = request.env["REQUEST_PATH"].sub(/\/$/, "/index.html").sub(/^\//, "")
      @file = File.join @cur_site.path, @path
    end
    
    def redirect_slash
      redirect_to "#{request.env["REQUEST_PATH"]}/"
    end
    
    def compile_scss
      return if @path !~ /\.css$/
      return if @path =~ /(^|\/)_[^\/]*$/
      return unless Storage.exists? @scss = @file.sub(/\.css$/, ".scss")
      
      css_mtime = Storage.exists?(@file) ? Storage.stat(@file).mtime : 0
      return if Storage.stat(@scss).mtime.to_i <= css_mtime.to_i
      
      css = ""
      begin
        opts = SS::Application.config.sass
        sass = Sass::Engine.new Storage.read(@scss), filename: @scss, syntax: :scss, cache: false,
          style: (opts.debug_info ? :expanded : :compressed),
          load_paths: opts.load_paths[1..-1],
          debug_info: opts.debug_info
        css = sass.render
      rescue Sass::SyntaxError => e
        msg = e.backtrace[0].sub(/.*?\/_\//, "")
        msg = "[#{msg}]\\A #{e}".gsub('"', '\\"')
        css = "body:before { position: absolute; top: 8px; right: 8px; display: block;"
        css << " padding: 4px 8px; border: 1px solid #b88; background-color: #fff;"
        css << " color: #822; font-size: 85%; font-family: tahoma, sans-serif; line-height: 1.6;"
        css << " white-space: pre; z-index: 9; content: \"#{msg}\"; }"
      end
      
      Storage.write @file, css
    end
    
    def x_sendfile
      return unless Storage.exists? @file
      response.headers["Expires"] = 1.days.from_now.httpdate if @file =~ /\.(css|js|gif|jpg|png)$/
      response.headers["Last-Modified"] = CGI::rfc1123_date(Storage.stat(@file).mtime)
      send_file @file, disposition: :inline, x_sendfile: true
    end
    
    def recognize_path(path)
      rec = Rails.application.routes.recognize_path(path, method: request.method) rescue {}
      rec[:cell] ? { controller: rec[:cell], action: rec[:action] } : nil
    end
    
    def render_part
      return if @path !~ /\.part\.(html|json)$/
      
      path = @path.sub(/\.json$/, ".html")
      page = Cms::Part.find_by(site_id: @cur_site, filename: path) rescue nil
      raise "404" unless page
      
      if page.route.present? && page.route != "cms/frees"
        cell = recognize_path "/.#{@cur_site.host}/part/#{page.route}.#{@path.sub(/.*\./, '')}"
        raise "404" unless cell
        params.merge! vars: { cur_site: @cur_site, cur_page: page }
        body = render_cell "#{page.route.sub('/', '/part/')}/view", cell[:action]
      else
        body = page.html
      end
      
      body = render_kana body
      
      respond_to do |format|
        format.html do
          @cur_page = page
          render inline: body, layout: "cms/part"
        end
        format.json do
          #body.gsub!(/^<header>.*?<\/header>/m, "")
          #body.gsub!(/^<nav>.*?<\/nav>/m, "")
          #body.gsub!(/^<footer>.*?<\/footer>/m, "")
          render json: body.to_json
        end
      end
    end
    
    def render_layout
      return if @path !~ /\.layout\.(html|json)$/
      
      path = @path.sub(/\.json$/, ".html")
      page = Cms::Layout.find_by(site_id: @cur_site, filename: path) rescue nil
      raise "404" unless page
      
      body = render_kana(page.render_html)
      
      respond_to do |format|
        format.html { render inline: "<!doctype html>\n#{body}" }
        format.json { render json: page.render_json(body) }
      end
    end
    
    def render_page
      page = Cms::Page.find_by(site_id: @cur_site, filename: @path) rescue nil 
      return unless page
      
      params.merge! vars: { cur_site: @cur_site, cur_page: page }
      body = render_cell "cms/page/page/view", "index"
      
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
      return if node.route.blank?
      return if node.route =~ /\/none$/
      
      rest = @path.sub(/^#{node.filename}/, "")
      cell = recognize_path "/.#{@cur_site.host}/node/#{node.route}#{rest}"
      return unless cell
      
      params.merge! vars: { cur_site: @cur_site, cur_node: node }
      body = render_cell "#{node.route.sub('/', '/node/')}/view", cell[:action]
      
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
    
    def rescue_action(e = nil)
      return render_error(e, status: 404) if e.to_s == "404"
      return render_error(e, status: 404) if e.is_a? Mongoid::Errors::DocumentNotFound
      return render_error(e, status: 404) if e.is_a? ActionController::RoutingError
      raise e
    end
    
    def render_error(e, opts = {})
      raise e if SS::Application.config.consider_all_requests_local
      status = opts[:status].presence || 500
      
      dir = "#{Rails.root}/public"
      dir = "#{@cur_site.path}" if @cur_site
      
      ["#{status}.html", "500.html"].each do |name|
        file = "#{dir}/#{name}"
        render(status: status, file: file, layout: false) and return if Storage.exists?(file)
      end
      render status: status, nothing: true
    end
end