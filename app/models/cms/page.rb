# coding: utf-8
class Cms::Page
  
  module Base
    extend ActiveSupport::Concern
    include SS::Document
    include SS::Site::Ref
    
    included do
      attr_accessor :cur_node # for UI
      
      seqid :id
      field :state, type: String
      field :name, type: String
      field :filename, type: String
      field :depth, type: Integer, metadata: { form: :none }
      
      validates :name, presence: true, length: { maximum: 80 }
      validates :filename, length: { maximum: 80 }
      
      validate :validate_node, if: -> { filename.present? }
      validate :validate_filename
      
      before_save :set_depth, if: -> { filename.present? }
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
        return true if filename.blank?
        return true if errors[:filename].size > 0
        
        self.filename = filename.downcase if filename =~ /[A-Z]/
        self.filename << ".html" unless filename.index(".")
        errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.html$/
      end
      
      def set_depth
        self.depth = filename.scan(/[^\/]+/).size
      end
  end
  
  include Base
  include Cms::Layout::Ref
  
  store_in collection: "cms_pages"
  
  field :keywords, type: SS::Fields::Words
  field :description, type: String, metadata: { form: :text }
  field :html, type: String, metadata: { form: :text }
  field :wiki, type: String, metadata: { form: :text }
  field :tiny, type: String, metadata: { form: :text }
  
  #embeds_many :html, class_name: "Cms::String"
  
  before_save :set_filename
      
  public
  
  private
    def set_filename
      if filename.blank?
        self.filename = @cur_node ? "#{@cur_node.filename}/#{id}.html" : "#{id}.html"
      end
    end
end
