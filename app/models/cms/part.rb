# coding: utf-8
class Cms::Part
  
  module Base
    extend ActiveSupport::Concern
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
  
  include Base
  
  class << self
    
    @@adons = []
    
    def addon(mod, name)
      path = "#{mod}/#{name}"
      name = I18n.translate path.singularize, scope: [:modules, :parts], default: path.titleize
      @@adons << [name, path]
    end
    
    def addons
      @@adons
    end
  end
end
