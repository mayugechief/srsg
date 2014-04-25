# coding: utf-8
module Cms::Part::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  
  included do
    store_in collection: "cms_parts"
    
    field :route, type: String
    field :html, type: String, metadata: { form: :code }
    
    permit_params :route, :html
    
    validates :filename, presence: true
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
      eid  = "part-#{path.object_id}"
      scr  = %Q[<script>SS.piece("##{eid}", "#{url.sub('.html', '.json')}");</script>]
      html = %Q[<div id="#{eid}"><a href="#{url}">#{name}</a></div>#{scr}]
      html = "<!-- part #{url.sub(/^\//, '')} -->#{html}<!-- /part -->"
    end
    
  private
    def validate_filename
      self.filename = filename.sub(/\..*$/, "") + ".part.html"
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.part\.html$/
    end
end
