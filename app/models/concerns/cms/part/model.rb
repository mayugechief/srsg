# coding: utf-8
module Cms::Part::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  
  included do |mod|
    store_in collection: "cms_parts"
    
    field :route, type: String
    permit_params :route
  end
  
  public
    def route_options
      Cms::Part.plugins
    end
    
    def becomes_with_route
      klass = route.sub("/", "/part/").singularize.camelize.constantize rescue nil
      return self unless klass
      
      item = klass.new
      instance_variables.each {|k| item.instance_variable_set k, instance_variable_get(k) }
      item
    end
    
    def render_html
      %Q[<a class="ss-part" href="#{url}" data-href="#{url.sub('.html', '.json')}">#{name}</a>]
    end
    
  private
    def fix_extname
      ".part.html"
    end
end
