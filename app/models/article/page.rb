# coding: utf-8
class Article::Page
  include Cms::Page::Model
  
  default_scope ->{ where(route: "article/page") }
  
  before_save :seq_filename, if: ->{ basename.blank? }
  
  private
    def validate_filename
      (@basename && @basename.blank?) ? nil : super
    end
    
    def seq_filename
      self.filename = dirname ? "#{dirname}/#{id}.html" : "#{id}.html"
    end
end
