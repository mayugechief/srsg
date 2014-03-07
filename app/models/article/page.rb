# coding: utf-8
class Article::Page
  include Cms::Page::Model
  
  scope :my_route, -> { where route: "article/pages" }
  
  before_validation :prepare_seq_filename, if: -> { filename.blank? }
  before_save :set_seq_filename
  
  private
    def prepare_seq_filename
      self.filename = "-.html"
    end
    
    def set_seq_filename
      return if filename !~ /(^|\/)-\.html$/
      self.filename = filename.sub(/-\.html/, "#{id}.html")
    end
end
