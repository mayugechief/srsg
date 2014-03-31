# coding: utf-8
module Cms::Page::Model
  extend ActiveSupport::Concern
  extend SS::Translation
  include Cms::Page::Feature
  include Cms::References::Layout
  
  included do
    store_in collection: "cms_pages"
    
    field :route, type: String, default: -> { "cms/pages" }
    field :keywords, type: SS::Extensions::Words
    field :description, type: String, metadata: { form: :text }
    
    permit_params :route, :keywords, :description
  end
end
