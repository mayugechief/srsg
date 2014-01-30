# coding: utf-8
class SS::Site
  
  module Ref
    extend ActiveSupport::Concern
    
    included do
      belongs_to :site, class_name: "SS::Site"
      scope :site_is, ->(doc) { where(site_id: doc._id) }
    end
  end
  
  include SS::Document
  
  seqid :id
  field :name, type: String
  field :host, type: String
  field :domain, type: String
  
  belongs_to :group, class_name: "SS::Group"
  has_many :pages, class_name: "Cms::Page", dependent: :destroy
  has_many :nodes, class_name: "Cms::Node", dependent: :destroy
  has_many :pieces, class_name: "Cms::Piece", dependent: :destroy
  has_many :layouts, class_name: "Cms::Layout", dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 40 }
  validates :host, presence: true, length: { minimum: 3, maximum: 16 }
  
  def path
    "#{self.class.root}/" + host.split(//).join("/") + "/_"
  end
  
  def url
    domain.index("/") ? domain.sub(/^.*?\//, "/") : "/"
  end
  
  def full_url
    "http://#{domain}/".sub(/\/+$/, "/")
  end
  
  class << self
    
    def root
      "#{Rails.root}/public/sites"
    end
  end
end
