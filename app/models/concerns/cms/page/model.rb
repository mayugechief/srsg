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
    
    after_save :generate_file
    after_destroy :remove_file
  end
  
  public
    #def current?(path)
    #  "/#{filename}" == "#{path.sub(/\.[^\.]+?$/, '.html')}" ? :current : nil
    #end
    
  private
    def generate_file
      if public?
        if @db_changes["filename"]
          src = "#{site.path}/#{@db_changes['filename'][0]}"
          dst = "#{site.path}/#{@db_changes['filename'][1]}"
          Fs.mv src, dst if Fs.exists?(src)
        end
        Cms::Task::PagesController.new.generate_file self if @db_changes.present?
      else
        remove_file
      end
    end
    
    def remove_file
      Fs.rm_rf path
    end
end
