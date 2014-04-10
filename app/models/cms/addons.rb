# coding: utf-8
module Cms::Addons
  module Meta
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do |mod|
      field :keywords, type: SS::Extensions::Words
      field :description, type: String, metadata: { form: :text }
      field :summary_html, type: String, metadata: { form: :text }
      permit_params :keywords, :description, :summary_html
    end
    
    def summary
      return summary_html if summary_html.present?
      return nil unless respond_to?(:html)
      html.gsub(/<("[^"]*"|'[^']*'|[^'">])*>/m, "").gsub(/\s+/, " ").truncate(120)
    end
  end
  
  module Body
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      field :html, type: String, metadata: { form: :text }
      field :wiki, type: String, metadata: { form: :text }
      permit_params :html
    end
  end
  
  module NodeList
    extend ActiveSupport::Concern
    extend SS::Addon
    include Cms::Addons::List::Model
  end
  
  module PageList
    extend ActiveSupport::Concern
    extend SS::Addon
    include Cms::Addons::List::Model
    
    def limit_options
      [ ["タイトル", "name"], ["ファイル名", "filename"],
        ["作成日時", "created"], ["更新日時", "updated -1"], ["公開日時", "published -1"] ]
    end
  end
end
