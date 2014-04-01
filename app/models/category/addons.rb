# coding: utf-8
module Category::Addons
  module Categories
    extend SS::Addon
    extend ActiveSupport::Concern
    
    included do
      embeds_ids :categories, class_name: "Category::Node"
      permit_params category_ids: []
    end
  end
end
