# coding: utf-8
class Cms::Part
  
  module Model
    extend ActiveSupport::Concern
    extend SS::Translation
    include Cms::Page::Feature
    
    included do
      store_in collection: "cms_parts"
      
      field :route, type: String
      field :html, type: String, metadata: { form: :code }
      
      validates :filename, presence: true
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
  
  include Model
  
  class << self
    
    @@plugins = []
    
    def plugin(mod, name)
      path = "#{mod}/#{name}"
      name = I18n.translate path.singularize, scope: [:modules, :parts], default: path.titleize
      @@plugins << [name, path]
    end
    
    def plugins
      @@plugins
    end
  end
end
