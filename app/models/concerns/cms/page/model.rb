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
  end
  
  public
    #def current?(path)
    #  "/#{filename}" == "#{path.sub(/\.[^\.]+?$/, '.html')}" ? :current : nil
    #end
end
