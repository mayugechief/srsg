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
  
  validates :filename, presence: true
  
  before_save :set_piece_paths
  
  public
    def render_html
      html = self.html.to_s.gsub(/<\/ piece ".+?" \/>/).each do |m|
        name = m.sub(/<\/ piece "(.+)?" \/>/, '\\1')
        path = name
        path << ".piece.html" unless path.index(".")
        path = "/" + (filename.index("/") ? File.dirname(filename) + "/" : "") + path if path[0] != '/'
        
        piece = Cms::Piece.where(site_id: site_id, filename: path.sub(/^\//, "")).first
        
        if piece && piece.route.present?
          pid = "piece-#{name.object_id}"
          %Q|<div id="#{pid}"><a href="#{path}">#{piece.name}</a></div>| +
            %Q|<script>SS.piece("##{pid}", "#{path.sub(".html", ".json")}");</script>|
        elsif piece
          piece.html
        else
          "<!-- #{path} -->"
        end
      end
    end
    
    def render_json(html = render_html)
      head = (html =~ /<head>/) ? html.sub(/^.*?<head>(.*?)<\/head>.*/im, "\\1") : ""
      body = (html =~ /<body/) ? html.sub(/^.*?(<body.*<\/body>).*/im, "\\1") : ""
      href = head.scan(/ (?:src|href)="(.*?)"/).map {|m| m[0]}.uniq.sort.join(",") rescue nil
      href = Digest::MD5.hexdigest href
      
      { head: head, body: body, href: href }.to_json
    end
    
  private
    def validate_filename
      return true if filename.blank?
      self.filename = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".layout.html" unless filename.index(".")
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.layout\.html$/
    end
    
    def set_piece_paths
      return true if html.blank?
      
      paths = []
      html.gsub(/<\/ piece ".+?" \/>/).each do |m|
        name = m.sub(/<\/ piece "(.+)?" \/>/, '\\1')
        code = "</ piece \"#{name.sub(/\.piece\.html$/, '')}\" />"
        path = name
        path << ".piece.html" unless path.index(".")
        path = "/" + (filename.index("/") ? File.dirname(filename) + "/" : "") + path if path[0] != '/'
        paths << path
        code
      end
      self.piece_paths = paths.uniq
    end
end
