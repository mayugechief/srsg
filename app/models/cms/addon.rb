# coding: utf-8
module Cms::Addon
  module Meta
    extend ActiveSupport::Concern
    extend SS::Addon
    
    set_order 100
    
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
    
    set_order 200
    
    included do
      field :html, type: String, metadata: { form: :text }
      permit_params :html
    end
  end
  
  module Body
    extend ActiveSupport::Concern
    extend SS::Addon
    
    set_order 200
    
    included do
      field :html, type: String, metadata: { form: :text }
      field :wiki, type: String, metadata: { form: :text }
      permit_params :html
    end
  end
  
  module Release
    extend ActiveSupport::Concern
    extend SS::Addon
    
    set_order 500
    
    included do
      #field :released, type: DateTime
      field :release_date, type: DateTime
      field :close_date, type: DateTime
      permit_params :released, :release_date, :close_date
      
      validate :validate_release_date
    end
    
    def validate_release_date
      if public? && released.blank?
        self.released = Time.now
      end
      
      if close_date.present? 
        if release_date.present? && release_date >= close_date 
          errors.add close_date, :greater_than, count: t(:release_date)
        end
      end
    end
  end
  
  module Tabs
    extend ActiveSupport::Concern
    extend SS::Addon
    
    set_order 200
    
    included do
      field :conditions, type: SS::Extensions::Words
      field :limit, type: Integer, default: 8
      field :new_days, type: Integer, default: 1
      permit_params :conditions, :limit, :new_days
      
      before_validation :validate_conditions
    end
    
    public
      def limit
        value = read_attribute(:limit).to_i
        (value < 1 || 100 < value) ? 100 : value
      end
    
      def new_days
        value = read_attribute(:new_days).to_i
        (value < 0 || 30 < value) ? 30 : value
      end
      
      def in_new_days?(date)
        date + new_days > Time.now
      end
      
    private
      def validate_conditions
        self.conditions = conditions.map do |m|
          m.strip.sub(/^\w+:\/\/.*?\//, "").sub(/^\//, "").sub(/\/$/, "")
        end.compact.uniq
      end
  end
  
  module NodeList
    extend ActiveSupport::Concern
    extend SS::Addon
    include Cms::Addon::List::Model
    
    set_order 200
    
    public
      def sort_options
        [ ["タイトル", "name"], ["ファイル名", "filename"],
          ["作成日時", "created"], ["更新日時", "updated -1"] ]
      end
      
      def sort_hash
        return { filename: 1 } if sort.blank?
        { sort.sub(/ .*/, "") => (sort =~ /-1$/ ? -1 : 1) }
      end
  end
  
  module PageList
    extend ActiveSupport::Concern
    extend SS::Addon
    include Cms::Addon::List::Model
    
    set_order 200
    
    public
      def sort_options
        [ ["タイトル", "name"], ["ファイル名", "filename"],
          ["作成日時", "created"], ["更新日時", "updated -1"], ["公開日時", "released -1"] ]
      end
      
      def sort_hash
        return { released: -1 } if sort.blank?
        { sort.sub(/ .*/, "") => (sort =~ /-1$/ ? -1 : 1) }
      end
  end
end
