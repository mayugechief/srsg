# coding: utf-8
module Cms::Addons::List
  module Model
    extend ActiveSupport::Concern
    
    included do |mod|
      field :order, type: String
      field :limit, type: Integer, default: 20
      field :loop_html, type: String
      field :upper_html, type: String
      field :lower_html, type: String
      permit_params :order, :limit, :loop_html, :upper_html, :lower_html
    end
    
    public
      def order_options
        [ ["タイトル", "name"], ["ファイル名", "filename"],
          ["作成日時", "created"], ["更新日時", "updated -1"] ]
      end
      
      def orders
        return nil if order.blank?
        { order.sub(/ .*/, "") => (order =~ /-1$/ ? -1 : 1) }
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
    
    private
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
