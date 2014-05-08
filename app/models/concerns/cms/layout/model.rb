# coding: utf-8
module Cms::Layout::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  include Cms::Addon::Html
  
  included do
    store_in collection: "cms_layouts"
    
    field :part_paths, type: SS::Extensions::Words, metadata: { form: :none }
    field :css_paths, type: SS::Extensions::Words, metadata: { form: :none }
    field :js_paths, type: SS::Extensions::Words, metadata: { form: :none }
    
    before_save :set_part_paths
    before_save :set_css_paths
    before_save :set_js_paths
  end
  
  public
    def render_html
      html = self.html.to_s.gsub(/<\/ part ".+?" \/>/).each do |m|
        path = m.sub(/<\/ part "(.+)?" \/>/, '\\1') + ".part.html"
        path = path[0] == "/" ? path.sub(/^\//, "") : dirname(path)
        
        part = Cms::Part.where(site_id: site_id, filename: path).first
        part = part.becomes_with_route if part
        part ? part.render_html : "<!-- #{path} -->"
      end
    end
    
    def render_json(html = render_html)
      head = (html =~ /<head>/) ? html.sub(/^.*?<head>(.*?)<\/head>.*/im, "\\1") : ""
      head.scan(/<link [^>]*href="([^"]*\.css)" [^>]*\/>/).uniq.each do |m|
        if (path = m[0]).index("//")
          head.gsub!(/"#{path}"/, "\"#{path}?_=$now\"") if path !~ /\?/
        else
          file  = "#{site.path}#{path}"
          data  = Fs.exists?(file) ? Fs.read(file) : "" rescue ""
          scss  = file.sub(/\.css$/, ".scss")
          data << Fs.read(scss) if Fs.exists?(scss) rescue ""
          head.gsub!(/"#{path}"/, "\"#{path}?_=#{Digest::MD5.hexdigest(data)}\"")
        end
      end
      
      body = (html =~ /<body/) ? html.sub(/^.*?(<body.*<\/body>).*/im, "\\1") : ""
      href = head.scan(/ (?:src|href)="(.*?)"/).map {|m| m[0]}.uniq.sort.join(",") rescue nil
      href = Digest::MD5.hexdigest href
      
      { head: head, body: body, href: href }.to_json
    end
    
  private
    def fix_extname
      ".layout.html"
    end
    
    def set_part_paths
      return true if html.blank?
      
      paths = html.scan(/<\/ part ".+?" \/>/).map do |m|
        path = m.sub(/<\/ part "(.+)?" \/>/, '\\1') + ".part.html"
        path = path[0] == "/" ? path.sub(/^\//, "") : dirname(path)
      end
      self.part_paths = paths.uniq
    end
    
    def  set_css_paths
      self.css_paths = html.scan(/<link [^>]*href="([^"]*\.css)" [^>]*\/>/).map {|m| m[0] }.uniq
    end
    
    def  set_js_paths
      self.js_paths = html.scan(/<script [^>]*src="([^"]*\.js)"[^>]*>/).map {|m| m[0] }.uniq
    end
end
