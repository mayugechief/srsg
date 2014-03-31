# coding: utf-8
module Cms::Page::Feature
  extend ActiveSupport::Concern
  include SS::Document
  include SS::References::Site
  include Acl::Addons::GroupOwner
  
  included do
    attr_accessor :cur_node # for UI
    
    seqid :id
    field :state, type: String
    field :name, type: String
    field :filename, type: String
    field :depth, type: Integer, metadata: { form: :none }
    
    index({ site_id: 1, filename: 1 }, { unique: true })
    
    permit_params :state, :name, :filename
    
    validates :name, presence: true, length: { maximum: 80 }
    validates :filename, uniqueness: { scope: :site_id }, length: { maximum: 80 }
    
    before_validation :validate_node, if: -> { filename.present? }
    validate :validate_filename
    
    before_save :set_depth, if: -> { filename.present? }
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
      "#{site.url}#{filename}"
    end
    
    def full_url
      "#{site.full_url}#{filename}"
    end
    
    def json_path
      "#{site.path}/" + filename.sub(/\.html/, ".json")
    end
    
    def json_url
      site.url + filename.sub(/\.html/, ".json")
    end
    
    def node
      return @node if @node
      return nil if depth == 1
      
      dirs = []
      names = File.dirname(filename).split('/')
      names.each {|name| dirs << (dirs.size == 0 ? name : "#{dirs.last}/#{name}") }
      
      @node = Cms::Node.where(site_id: site_id, :filename.in => dirs).sort(depth: -1).first
    end
    
  private
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
    
    def validate_filename
      return if errors[:filename].present?
      return errors.add :filename, :blank if filename.blank?
      
      self.filename = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".html" if filename =~ /(^|\/)[\w\-]+$/
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.html$/
    end
    
    def set_depth
      self.depth = filename.scan(/[^\/]+/).size
    end
end
