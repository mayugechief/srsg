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
      field :shortcut, type: Integer
      
      index({ site_id: 1, filename: 1 }, { unique: true })
      
      validates :name, presence: true, length: { maximum: 80 }
      validates :filename, uniqueness: { scope: :site_id }, presence: true, length: { maximum: 2000 }
      validates :route, presence: true
      
      validate :validate_filename
      validate :validate_node, if: -> { filename.present? }
      
      before_save :set_depth, if: -> { filename.present? }
      after_destroy :destroy_children
    end
    
    module ClassMethods
      
      def node(node)
        where filename: /^#{node.filename}\//, depth: node.depth + 1
      end
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
        return @parent unless @parent.nil?
        return @parent = false if depth == 1 || !filename.to_s.index("/")
        
        dirs  = []
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
      
      def parts
        Cms::Part.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
      def layouts
        Cms::Layout.where(site_id: site_id, filename: /^#{filename}\//)
      end
      
    private
      def validate_filename
        return if errors[:filename].present?
        return errors.add :filename, :blank if filename.blank?
        
        self.filename = filename.downcase if filename =~ /[A-Z]/
        self.filename = filename.sub(/\/$/, "")
        errors.add :filename, :invalid if filename !~ /^[\w\-\/]+$/
      end
      
      def validate_node
        return if errors[:filename].present?
        
        if @cur_node #TODO:
          if filename.index("/")
            errors.add :filename, :invalid if File.dirname(filename) != @cur_node.filename
          else
            self.filename = "#{@cur_node.filename}/#{filename}"
          end
        elsif @cur_node == false
          errors.add :filename, :invalid if filename.index("/")
        end
      end
      
      def set_depth
        self.depth = filename.scan(/[^\/]+/).size
      end
      
      def destroy_children
        nodes.destroy
        pages.destroy
        parts.destroy
        layouts.destroy
      end
    
    class << self
      
      def model_name #TODO:
        ActiveModel::Name.new(self)
      end
    end
  end
  
  include Base
  
  class << self
    
    @@addons = []
    
    def addon(mod, name)
      path = "#{mod}/#{name}"
      name = I18n.translate path.singularize, scope: [:modules, :nodes], default: path.titleize
      @@addons << [name, path]
    end
    
    def addons
      @@addons
    end
    
    def modules
      keys = @@addons.map {|m| m[1].sub(/\/.*/, "") }.uniq
      keys.map do |key|
        name = I18n.translate key, scope: [:modules, :contents], default: key.to_s.titleize
        [name, key]
      end
    end
  end
end
