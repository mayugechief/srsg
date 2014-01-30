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
      field :type, type: String, metadata: { form: :none }
      
      validates :name, presence: true, length: { maximum: 80 }
      validates :filename, presence: true, length: { maximum: 2000 }
      validates :route, presence: true
      validates :type, presence: true
      
      validate :validate_filename
      
      before_save :set_depth, if: -> { filename.present? }
      after_destroy :destroy_pages
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
      
      def where(cond = {})
        self.class.where({ filename: /^#{filename}\// }.merge(cond))
      end
      
      def children
        where depth: depth + 1
      end
      
      def pages
        Cms::Page.where(filename: /^#{filename}/)
      end
      
      def pieces
        Cms::Piece.where(filename: /^#{filename}/)
      end
      
      def layouts
        Cms::Layout.where(filename: /^#{filename}/)
      end
      
    private
      def validate_filename
        errors.add :filename, :invalid if filename !~ /^[\w\-\/]+$/
      end
      
      def set_filename
        self.filename = filename.downcase if filename =~ /[A-Z]/
      end
      
      def set_depth
        self.depth = filename.scan(/[^\/]+/).size
      end
      
      def destroy_pages
        where.destroy
        pages.destroy
        pieces.destroy
        layouts.destroy
      end
  end
  
  include Base
end
