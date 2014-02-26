# coding: utf-8
module Cms::PageFilter
  
  module ViewCell
    extend ActiveSupport::Concern
    
    included do
      helper ApplicationHelper
      before_action :inherit_vars
    end
    
    private
      def inherit_vars
        params[:vars].each {|key, val| instance_variable_set "@#{key}", val }
      end
  end
end
