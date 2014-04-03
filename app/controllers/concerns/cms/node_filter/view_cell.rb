# coding: utf-8
module Cms::NodeFilter::ViewCell
  extend ActiveSupport::Concern
  include SS::FeedFilter
  
  included do
    helper ApplicationHelper
    before_action :inherit_variables
  end
  
  private
    def inherit_variables
      controller.instance_variables.select {|m| m =~ /^@[a-z]/ }.each do |name|
        instance_variable_set name, controller.instance_variable_get(name)
      end
    end
    
    def redirect_to(*args)
      controller.redirect_to(*args)
    end
end
