# coding: utf-8
class Cms::Node
  
  module Base
    extend ActiveSupport::Concern
    include SS::Document
    include SS::Site::Ref
    include Cms::Layout::Ref
    
    included do
      store_in collection: "cms_nodes"
      
      attr_accessor :cur_node # for UI
      
      seqid :id
      field :state, type: String
      field :name, type: String
      field :filename, type: String
      field :depth, type: Integer, metadata: { form: :none }
      field :route, type: String
      #field :type, type: String, metadata: { form: :none }
      field :shortcut, type: Integer
      
      index({ site_id: 1, filename: 1 }, { unique: true })
      
      validates :name, presence: true, length: { maximum: 80 }
      validates :filename, presence: true, length: { maximum: 2000 }
      #validates :route, presence: true
      #validates :type, presence: true
      
      validate :validate_node
      validate :validate_filename
      
      before_save :set_depth, if: -> { filename.present? }
      after_destroy :destroy_children
    end
    
    public
      def path
        "#{site.path}/#{filename}"
      end
      
      def url
        "#{site.url}#{filename}/"
      end
      
      def full_url
        "#{site.full_url}#{filename}/"
      end
      
      def parents
        last = nil
        dirs = filename.split('/').map {|n| last = last ? "#{last}/#{n}" : n }
        dirs.pop
        Cms::Node.where(site_id: site_id, :filename.in => dirs).sort(depth: 1)
      end
      
      def parent
        return @parent if @parent
        return nil if depth == 1
        
        dirs = []
        names = File.dirname(filename).split('/')
        names.each {|name| dirs << (dirs.size == 0 ? name : "#{dirs.last}/#{name}") }
        
        @parent = Cms::Node.where(site_id: site_id, :filename.in => dirs).sort(depth: -1).first
      end
      
      def nodes
        self.class.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
      def children
        nodes.where depth: depth + 1
      end
      
      def pages
        Cms::Page.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
      def pieces
        Cms::Piece.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
      def layouts
        Cms::Layout.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
    private
      def validate_node
        if @cur_node
          if filename.index("/")
            errors.add :filename, :invalid if File.dirname(filename) != @cur_node.filename
          else
            self.filename = "#{@cur_node.filename}/#{filename}"
          end
        elsif @cur_node == false #TODO:
          errors.add :filename, :invalid if filename.index("/")
        end
      end
      
      def validate_filename
        return true if errors[:filename].size > 0
        errors.add :filename, :invalid if filename !~ /^[\w\-\/]+$/
      end
      
      def set_filename
        self.filename = filename.downcase if filename =~ /[A-Z]/
      end
      
      def set_depth
        self.depth = filename.scan(/[^\/]+/).size
      end
      
      def destroy_children
        nodes.destroy
        pages.destroy
        pieces.destroy
        layouts.destroy
      end
  end
  
  include Base
  
  @@routes = []
  
  class << self
    
    def route(path)
      @@routes << [path.titleize.sub("/", " : "), path]
    end
    
    def routes
      @@routes
    end
  end
end
