# coding: utf-8
module Cms::References
  module Layout
    extend ActiveSupport::Concern
    
    included do
      belongs_to :layout, class_name: "Cms::Layout"
      permit_params :layout_id
      scope :layout_is, ->(doc) { where(layout_id: doc._id) }
    end
  end
end
