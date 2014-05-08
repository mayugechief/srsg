# coding: utf-8
module Cms::Addon
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
  
  module Html
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      field :html, type: String, metadata: { form: :text }
      permit_params :html
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
    include Cms::Addon::List::Model
  end
  
  module PageList
    extend ActiveSupport::Concern
    extend SS::Addon
    include Cms::Addon::List::Model
    
    included do |mod|
      field :conditions, type: SS::Extensions::Words
      permit_params :conditions
      
      before_validation :validate_conditions
    end
    
    public
      def limit_options
        [ ["タイトル", "name"], ["ファイル名", "filename"],
          ["作成日時", "created"], ["更新日時", "updated -1"], ["公開日時", "published -1"] ]
      end
      
      def condition_hash
        cond = []
        cids = []
        
        if respond_to?(:node) # from parts
          if node
            cond << { filename: /^#{node.filename}\//, depth: depth }
            cids << node.id
          else
            cond << { depth: depth }
          end
        else # from nodes
          cond << { filename: /^#{filename}\//, depth: depth + 1 }
          cids << id
        end
        
        conditions.each do |url|
          node = Cms::Node.where(filename: url).first
          next unless node
          cond << { filename: /^#{node.filename}\//, depth: node.depth + 1 }
          cids << node.id
        end
        cond << { :category_ids.in => cids } if cids.present?
        
        { '$or' => cond }
      end
      
    private
      def validate_conditions
        self.conditions = conditions.map do |m|
          m.strip.sub(/^\w+:\/\/.*?\//, "").sub(/^\//, "").sub(/\/$/, "")
        end.compact.uniq
      end
  end
end
