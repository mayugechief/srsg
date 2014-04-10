# coding: utf-8
module Cms::NodeFilter::ViewCell
  extend ActiveSupport::Concern
  include SS::FeedFilter
  
  included do
    helper ApplicationHelper
    before_action :prepend_current_view_path
    before_action :inherit_variables
    before_action :set_item
  end
  
  module ClassMethods
    def model(cls)
      self.model_class = cls if cls
    end
  end
  
  private
    def prepend_current_view_path
      prepend_view_path "app/cells/#{controller_path}"
    end
    
    def inherit_variables
      controller.instance_variables.select {|m| m =~ /^@[a-z]/ }.each do |name|
        next if instance_variable_defined?(name)
        instance_variable_set name, controller.instance_variable_get(name)
      end
    end
    
    def set_model
      @model = self.class.model_class
      controller.instance_variable_set :@model, @model
    end
    
    def set_item
      @cur_node = @cur_node.becomes_with_route
    end
    
    def redirect_to(*args)
      controller.redirect_to(*args)
    end
end
