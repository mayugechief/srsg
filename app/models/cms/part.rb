# coding: utf-8
class Cms::Part
  
  module Base
    extend ActiveSupport::Concern
    include Cms::Page::Base
    
    included do
      store_in collection: "cms_parts"
      
      field :route, type: String
      field :html, type: String, metadata: { form: :code }
      
      validates :filename, presence: true
    end
    
    private
      def validate_filename
        return true if filename.blank?
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
      @@adons << [path.titleize, path]
    end
    
    def addons
      @@adons
    end
  end
end
