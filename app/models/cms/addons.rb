# coding: utf-8
module Cms::Addons
  module Tiny
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do |mod|
      field :tiny, type: String, metadata: { form: :text }
      permit_params :tiny
    end
  end
  
  module Wiki
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      field :wiki, type: String, metadata: { form: :text }
      permit_params :wiki
    end
  end
  
  module Html
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      field :html, type: String, metadata: { form: :text }
      permit_params :html
    end
  end
end
