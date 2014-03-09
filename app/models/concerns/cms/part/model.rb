# coding: utf-8
module Cms::Part::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  
  included do
    store_in collection: "cms_parts"
    
    field :route, type: String
    field :html, type: String, metadata: { form: :code }
  end
  
  private
    def validate_filename
      return if errors[:filename].present?
      return errors.add :filename, :blank if filename.blank?
      
      self.filename = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".part.html" unless filename.index(".")
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.part\.html$/
    end
end
