# coding: utf-8
module Cms::Addon::List
  module Model
    extend ActiveSupport::Concern
    extend SS::Translation
    
    included do |mod|
      field :conditions, type: SS::Extensions::Words
      field :sort, type: String
      field :limit, type: Integer, default: 20
      field :loop_html, type: String
      field :upper_html, type: String
      field :lower_html, type: String
      permit_params :conditions, :sort, :limit, :loop_html, :upper_html, :lower_html
      
      before_validation :validate_conditions
    end
    
    public
      def sort_options
        []
      end
      
      def sort_hash
        {}
      end
      
      def limit
        value = read_attribute(:limit).to_i
        (value < 1 || 100 < value) ? 100 : value
      end
      
      def render_loop_html(item)
        loop_html.gsub(/\#\{(.*?)\}/) do |m|
          str = eval_loop_variable($1, item) rescue false
          str == false ? m : str
        end
      end
      
      def condition_hash
        cond = []
        cids = []
        
        if respond_to?(:node) # parts
          if node
            cond << { filename: /^#{node.filename}\//, depth: depth }
            cids << node.id
          else
            cond << { depth: depth }
          end
        else # nodes
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
      
      def eval_loop_variable(name, item)
        if name =~ /^(name|url|summary)$/
          item.send name
        elsif name == "class"
          item.basename.sub(/\..*/, "").dasherize
        elsif name == "date"
          I18n.l item.date.to_date
        elsif name =~ /^date\.(\w+)$/
          I18n.l item.date.to_date, format: $1.to_sym
        elsif name == "time"
          I18n.l item.date
        elsif name =~ /^time\.(\w+)$/
          I18n.l item.date, format: $1.to_sym
        else
          false
        end
      end
  end
end
