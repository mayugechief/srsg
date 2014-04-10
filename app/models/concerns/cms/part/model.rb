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
  end
  
  public
    def becomes_with_route
      klass = route.sub("/", "/part/").singularize.camelize.constantize rescue nil
      return self unless klass
      
      item = klass.new
      instance_variables.each {|k| item.instance_variable_set k, instance_variable_get(k) }
      item
    end
    
    def render_html
      json = url.sub('.html', '.json')
      eid  = "part-#{path.object_id}"
      scr  = %Q[<script>SS.piece("##{eid}", "#{json}?ref=" + location.pathname);</script>]
      html = %Q[<div id="#{eid}"><a href="#{url}">#{name}</a></div>#{scr}]
      html = "<!-- part #{path} -->#{html}<!-- /part -->"
    end
    
    def route_options
      Cms::Part.plugins
    end
    
  private
    def validate_filename
      return if errors[:filename].present?
      return errors.add :filename, :blank if filename.blank?
      
      self.filename = filename.downcase if filename =~ /[A-Z]/
      self.filename << ".part.html" unless filename.index(".")
      errors.add :filename, :invalid if filename !~ /^([\w\-]+\/)*[\w\-]+\.part\.html$/
    end
end
