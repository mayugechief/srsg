# coding: utf-8
class Article::Page
  include Cms::Page::Model
  
  default_scope ->{ where(route: "article/pages") }
  
  before_save :set_filename, if: ->{ filename.blank? }
  
  private
    def set_filename
      @cur_node.filename
      self.filename = @cur_node ? "#{@cur_node.filename}/#{id}.html" : "#{id}.html"
    end
end
