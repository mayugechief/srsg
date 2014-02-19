# coding: utf-8
class Cms::Piece
  include Cms::Page::Base
  
  field :route, type: String
  field :html, type: String, metadata: { form: :code }
  
  validates :filename, presence: true
  
  public
  
  private
    def validate_filename
      return true if filename.blank?
      self.filename = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".piece.html" unless filename.index(".")
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.piece\.html$/
    end
  
  class << self
    
    @@routes = []
    
    def route(path)
      @@routes << [path.titleize, path]
    end
    
    def routes
      @@routes
    end
    
    def modules
      keys = @@routes.map {|m| m[1].sub(/\/.*/, "") }.uniq
      keys.map {|m| [m.titleize, m] }
    end
  end
end
