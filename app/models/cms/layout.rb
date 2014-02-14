# coding: utf-8
class Cms::Layout
  
  module Ref
    extend ActiveSupport::Concern
    
    included do
      belongs_to :layout, class_name: "Cms::Layout"
      scope :layout_is, ->(doc) { where(layout_id: doc._id) }
    end
  end
  
  include Cms::Page::Base
  
  field :html, type: String, metadata: { form: :code }
  field :piece_paths, type: SS::Fields::Words, metadata: { form: :none }
  field :css_paths, type: SS::Fields::Words, metadata: { form: :none }
  field :js_paths, type: SS::Fields::Words, metadata: { form: :none }
  
  validates :filename, presence: true
  
  before_save :set_piece_paths
  before_save :set_css_paths
  before_save :set_js_paths
  
  public
    def render_html
      html = self.html.to_s.gsub(/<\/ piece ".+?" \/>/).each do |m|
        path  = filename.index("/") ? File.dirname(filename) + "/" : ""
        path << m.sub(/<\/ piece "(.+)?" \/>/, '\\1') + ".piece.html"
        path  = path.sub(/^\//, "")
        piece = Cms::Piece.where(site_id: site_id, filename: path).first
        
        if piece && piece.route.present?
          eid = "piece-#{path.object_id}"
          scr = %Q|<script>SS.piece("##{eid}", "#{path.sub('.html', '.json')}");</script>|
          htm = %Q|<div id="#{eid}"><a href="#{path}">#{piece.name}</a></div>#{scr}|
        elsif piece
          piece.html
        else
          "<!-- #{path} -->"
        end
      end
    end
    
    def render_json(html = render_html)
      head = (html =~ /<head>/) ? html.sub(/^.*?<head>(.*?)<\/head>.*/im, "\\1") : ""
      head.scan(/<link [^>]*href="([^"]*\.css)" [^>]*\/>/).uniq.each do |m|
        if (path = m[0]) =~ /^\/\//
          head.gsub!(/"#{path}"/, "\"#{path}?_=$now\"") if path !~ /\?/
        else
          file = "#{site.path}#{path}"
          scss = file.sub(/\.css$/, ".scss")
          data = Storage.exists?(scss) ? Storage.read(scss) : Storage.read(file) rescue ""
          head.gsub!(/"#{path}"/, "\"#{path}?_=#{Digest::MD5.hexdigest(data)}\"")
        end
      end
      
      body = (html =~ /<body/) ? html.sub(/^.*?(<body.*<\/body>).*/im, "\\1") : ""
      href = head.scan(/ (?:src|href)="(.*?)"/).map {|m| m[0]}.uniq.sort.join(",") rescue nil
      href = Digest::MD5.hexdigest href
      
      { head: head, body: body, href: href }.to_json
    end
    
  private
    def validate_filename
      return true if filename.blank?
      self.filename  = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".layout.html" unless filename.index(".")
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.layout\.html$/
    end
    
    def set_piece_paths
      return true if html.blank?
      
      paths = html.scan(/<\/ piece ".+?" \/>/).map do |m|
        path  = filename.index("/") ? File.dirname(filename) + "/" : ""
        path << m.sub(/<\/ piece "(.+)?" \/>/, '\\1') + ".piece.html"
        path  = path.sub(/^\//, "")
      end
      self.piece_paths = paths.uniq
    end
    
    def  set_css_paths
      self.css_paths = html.scan(/<link [^>]*href="([^"]*\.css)" [^>]*\/>/).map {|m| m[0] }.uniq
    end
    
    def  set_js_paths
      self.js_paths = html.scan(/<script [^>]*src="([^"]*\.js)"[^>]*>/).map {|m| m[0] }.uniq
    end
end
