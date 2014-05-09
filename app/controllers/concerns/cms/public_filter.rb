# coding: utf-8
module Cms::PublicFilter
  extend ActiveSupport::Concern
  
  cattr_accessor(:filters) { [] }
  
  included do
    rescue_from StandardError, with: :rescue_action
    before_action :set_site
    before_action :set_path
    before_action :redirect_slash, if: ->{ request.env["REQUEST_PATH"] =~ /\/[^\.]+[^\/]$/ }
    before_action :deny_path
    before_action :parse_path
    before_action :compile_scss
    before_action :x_sendfile
  end
  
  public
    def index
      if @html =~ /\.layout\.html$/
        layout = find_layout(@html)
        raise "404" unless layout
        send_layout render_layout(layout)
        
      elsif @html =~ /\.part\.html$/
        part = find_part(@html)
        raise "404" unless part
        send_part render_part(part)
        
      else
        page = find_page(@html)
        send_page render_page(page) if page
        
        if response.body.blank?
          node = find_node(@html)
          raise "404" unless node
          send_node render_node(node)
        end
      end
      raise "404" if response.body.blank?
      
      cover_layout unless ajax_layout?
    end
  
  private
    def ajax_layout?
      @ajax_layout.nil? ? SS.config.cms.ajax_layout : @ajax_layout
    end
    
    def set_site
      @cur_site ||= SS::Site.find_by domains: request.env["HTTP_HOST"] rescue nil
      @cur_site ||= SS::Site.first if Rails.env.development?
      raise "404" if !@cur_site
    end
    
    def set_path
      @path ||= request.env["REQUEST_PATH"]
      
      path = @path.dup
      @@filters.each do |name|
        send("set_path_with_#{name}")
        if path != @path
          @filter = name
          break
        end
      end
    end
    
    def redirect_slash
      redirect_to "#{request.env["REQUEST_PATH"]}/"
    end
    
    def deny_path
      raise "404" if @path =~ /^\/sites\/.\//
    end
    
    def parse_path
      @path = @path.sub(/\/$/, "/index.html").sub(/^\//, "")
      @html = @path.sub(/^\//, "").sub(/\.\w+$/, ".html")
      @file = File.join @cur_site.path, @path
    end
    
    def compile_scss
      return if @path !~ /\.css$/
      return if @path =~ /(^|\/)_[^\/]*$/
      return unless Fs.exists? @scss = @file.sub(/\.css$/, ".scss")
      
      css_mtime = Fs.exists?(@file) ? Fs.stat(@file).mtime : 0
      return if Fs.stat(@scss).mtime.to_i <= css_mtime.to_i
      
      css = ""
      begin
        opts = Rails.application.config.sass
        sass = Sass::Engine.new Fs.read(@scss), filename: @scss, syntax: :scss, cache: false,
          style: (opts.debug_info ? :expanded : :compressed),
          load_paths: opts.load_paths[1..-1],
          debug_info: opts.debug_info
        css = sass.render
      rescue Sass::SyntaxError => e
        msg  = e.backtrace[0].sub(/.*?\/_\//, "")
        msg  = "[#{msg}]\\A #{e}".gsub('"', '\\"')
        css  = "body:before { position: absolute; top: 8px; right: 8px; display: block;"
        css << " padding: 4px 8px; border: 1px solid #b88; background-color: #fff;"
        css << " color: #822; font-size: 85%; font-family: tahoma, sans-serif; line-height: 1.6;"
        css << " white-space: pre; z-index: 9; content: \"#{msg}\"; }"
      end
      
      Fs.write @file, css
    end
    
    def x_sendfile
      return unless Fs.exists? @file
      response.headers["Expires"] = 1.days.from_now.httpdate if @file =~ /\.(css|js|gif|jpg|png)$/
      response.headers["Last-Modified"] = CGI::rfc1123_date(Fs.stat(@file).mtime)
      send_file @file, disposition: :inline, x_sendfile: true
    end
    
    def recognize_path(path)
      rec = Rails.application.routes.recognize_path(path, method: request.method) rescue {}
      return nil unless rec[:cell]
      params.merge!(rec)
      { controller: rec[:cell], action: rec[:action] }
    end
    
    # layout
    
    def find_layout(path)
      layout = Cms::Layout.find_by(site_id: @cur_site, filename: path) rescue nil
      return nil unless layout
      @preview || layout.public? ? layout : nil
    end
    
    def render_layout(layout)
      @cur_layout = layout
      respond_to do |format|
        format.html { layout.render_html }
        format.json { layout.render_json }
      end
    end
    
    def send_layout(body)
      respond_to do |format|
        format.html { render inline: body }
        format.json { render json: body }
      end
    end
    
    # part
    
    def find_part(path)
      part = Cms::Part.find_by(site_id: @cur_site, filename: path) rescue nil
      return unless part
      @preview || part.public?  ? part : nil
    end
    
    def render_part(part, path = @path)
      return part.html if part.route == "cms/frees"
      cell = recognize_path "/.#{@cur_site.host}/parts/#{part.route}.#{path.sub(/.*\./, '')}"
      return unless cell
      @cur_part = part
      render_cell part.route.sub(/\/.*/, "/#{cell[:controller]}/view"), cell[:action]
    end
    
    def send_part(body)
      respond_to do |format|
        format.html { render inline: body, layout: (request.xhr? ? false : "cms/part") }
        format.json { render json: body.to_json }
      end
    end
    
    # page
    
    def find_page(path)
      page = Cms::Page.find_by(site_id: @cur_site, filename: path) rescue nil
      return unless page
      @preview || page.public? ? page : nil
    end
    
    def render_page(page)
      cell = recognize_path "/.#{@cur_site.host}/pages/#{page.route}/#{page.basename}"
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
    
    def find_node(path)
      dirs  = []
      names = path.sub(/\/[^\/]+$/, "").split('/')
      names.each {|name| dirs << (dirs.size == 0 ? name : "#{dirs.last}/#{name}") }
      
      node = Cms::Node.where(site_id: @cur_site.id, :filename.in => dirs).sort(depth: -1).first
      return unless node
      @preview || node.public? ? node : nil
    end
    
    def render_node(node, path = @path)
      rest = path.sub(/^#{node.filename}/, "")
      cell = recognize_path "/.#{@cur_site.host}/nodes/#{node.route}#{rest}"
      return unless cell
      
      @cur_node   = node
      @cur_layout = node.layout
      render_cell node.route.sub(/\/.*/, "/#{cell[:controller]}/view"), cell[:action]
    end
    
    def send_node(body)
      return unless body
      respond_to do |format|
        format.html { render inline: body, layout: "cms/page" }
        format.json { render json: body }
        format.xml  { render xml: body }
      end
    end
    
    def rescue_action(e = nil)
      return render_error(e, status: 404) if e.to_s == "404"
      return render_error(e, status: 404) if e.is_a? Mongoid::Errors::DocumentNotFound
      return render_error(e, status: 404) if e.is_a? ActionController::RoutingError
      raise e
    end
    
    def render_error(e, opts = {})
      raise e if Rails.application.config.consider_all_requests_local
      status = opts[:status].presence || 500
      
      dir = "#{Rails.root}/public"
      dir = "#{@cur_site.path}" if @cur_site
      
      ["#{status}.html", "500.html"].each do |name|
        file = "#{dir}/#{name}"
        render(status: status, file: file, layout: false) and return if Fs.exists?(file)
      end
      render status: status, nothing: true
    end
    
    def cover_layout
      body = response.body
      
      head = body.match(/<header.*?<\/header>/m).to_s
      site_name = head =~ /<[^>]+ id="ss-site-name".*?>(.*?)</m ? $1 : nil
      page_name = head =~ /<[^>]+ id="ss-page-name".*?>(.*?)</m ? $1 : nil
      
      if @cur_layout
        @ref = "/#{@path}"
        data = ActiveSupport::JSON.decode(@cur_layout.render_json)
        
        main = body =~ /<!-- yield -->(.*)<!-- \/yield -->/m ? $1 : body
        main = data["body"].sub(/<\/ yield \/>/, main)
        
        body.sub!("</head>", "#{data['head']}</head>")
        body.sub!(/<body.*<\/body>/m, main)
        
        body.gsub!(/<a( [^>]*?class="ss-part"[^>]*?)>.*?<\/a>/m) do |m|
          path = (m =~ / href=/) ? m.sub(/.* href="(.*?)".*/, '\\1').sub(/^\//, '') : nil
          part = find_part(path)
          part ? render_part(part, path) : m
        end
        
        body.sub!(/(<[^>]+ id="ss-site-name".*?>)[^<]+/, "\\1#{site_name}")
        body.sub!(/(<[^>]+ id="ss-page-name".*?>)[^<]+/, "\\1#{page_name}")
      end
      
      response.body = body
    end
    
  class << self
    def filter(name)
      @@filters << name
    end
  end
end
