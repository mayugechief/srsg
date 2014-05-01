# coding: utf-8
module Cms::Node::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include SS::Document
  include SS::References::Site
  include Cms::References::Layout
  include Acl::Addon::GroupOwner
  include Cms::Addon::Meta
  
  attr_accessor :cur_node, :basename
  
  included do
    store_in collection: "cms_nodes"
    index({ site_id: 1, filename: 1 }, { unique: true })
    
    scope :public, ->{ where(state: "public") }
    
    seqid :id
    field :state, type: String, default: "public"
    field :name, type: String
    field :filename, type: String
    field :depth, type: Integer, metadata: { form: :none }
    field :route, type: String
    field :shortcut, type: String
    
    permit_params :state, :name, :filename, :basename, :route, :shortcut
    
    validates :state, presence: true
    validates :name, presence: true, length: { maximum: 80 }
    validates :filename, uniqueness: { scope: :site_id }, length: { maximum: 200 }
    validates :route, presence: true
    
    before_validation :set_filename
    before_validation :validate_filename
    after_validation :set_depth, if: ->{ filename.present? }
    
    before_save :set_db_changes
    after_save :rename_children
    after_destroy :destroy_children
  end
  
  module ClassMethods
    def node(node)
      node ? where(filename: /^#{node.filename}\//, depth: node.depth + 1) : where(depth: 1)
    end
  end
  
  public
    def becomes_with_route
      klass = route.sub("/", "/node/").singularize.camelize.constantize rescue nil
      return self unless klass
      
      item = klass.new
      instance_variables.each {|k| item.instance_variable_set k, instance_variable_get(k) }
      item
    end
    
    def dirname
      filename.index("/") ? filename.to_s.sub(/\/.*$/, "").presence : nil
    end
    
    def basename
      @basename || filename.to_s.sub(/.*\//, "").presence
    end
    
    def path
      "#{site.path}/#{filename}"
    end
    
    def url
      "#{site.url}#{filename}/"
    end
    
    def full_url
      "#{site.full_url}#{filename}/"
    end
    
    #def current?(path)
    #  "/#{filename}/" =~ /^#{path.sub(/\.[^\.]+?$/, '')}/ ? :current : nil
    #end
    
    def date
      updated || created
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
    
    def children(cond = {})
      nodes.where cond.merge(depth: depth + 1)
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
    
    def route_options
      Cms::Node.plugins
    end
    
    def state_options
      [ %w[公開 public], %w[非公開 closed] ]
    end
    
    def shortcut_options
      [ %w[表示 show], %w[非表示 hide] ]
    end
    
  private
    def set_filename
      if @cur_node
        self.filename = "#{@cur_node.filename}/#{basename}"
      elsif @basename
        self.filename = basename
      end
    end
    
    def validate_filename
      if @basename
        return errors.add :basename, :empty if @basename.blank?
        errors.add :basename, :invalid if filename !~ /^[\w\-]+(\/[\w\-]+)*$/
      else
        return errors.add :filename, :empty if filename.blank?
        errors.add :filename, :invalid if filename !~ /^[\w\-]+(\/[\w\-]+)*$/
      end
    end
    
    def set_depth
      self.depth = filename.scan("/").size + 1
    end
    
    def set_db_changes
      @db_changes = new_record? ? {} : changes || {}
    end
    
    def rename_children
      return unless @db_changes["filename"]
      
      src, dst = @db_changes["filename"]
      %w(nodes pages parts layouts).each do |name|
        send(name).where(filename: /^#{src}\//).each do |item|
          item.filename = item.filename.sub(/^#{src}\//, "#{dst}\/")
          item.save validate: false
        end
      end
    end
    
    def destroy_children
      %w(nodes pages parts layouts).each do |name|
        send(name).destroy
      end
    end
end
