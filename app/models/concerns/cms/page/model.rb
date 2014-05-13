# coding: utf-8
module Cms::Page::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  include Cms::References::Layout
  
  included do
    store_in collection: "cms_pages"
    
    field :route, type: String, default: ->{ "cms/page" }
    permit_params :route
    
    after_save :rename_file, if: ->{ @db_changes }
    after_save :generate_file, if: ->{ @db_changes }
    after_save :remove_file, if: ->{ @db_changes && @db_changes["state"] && !public? }
    after_destroy :remove_file
  end
  
  public
    #def current?(path)
    #  "/#{filename}" == "#{path.sub(/\.[^\.]+?$/, '.html')}" ? :current : nil
    #end
    
    def generate_file
      return unless public?
      Cms::Task::PagesController.new.generate_file(self)
    end
    
  private
    def rename_file
      return unless @db_changes["filename"]
      return unless @db_changes["filename"][0]
      
      src = "#{site.path}/#{@db_changes['filename'][0]}"
      dst = "#{site.path}/#{@db_changes['filename'][1]}"
      Fs.mv src, dst if Fs.exists?(src)
    end
    
    def remove_file
      Fs.rm_rf path
    end
end
