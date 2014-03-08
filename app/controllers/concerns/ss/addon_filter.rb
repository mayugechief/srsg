# coding: utf-8
module SS::AddonFilter
  module EditCell
    extend ActiveSupport::Concern
    
    included do
      helper ApplicationHelper
      helper AddonHelper
      before_action :inherit_variables
    end
    
    private
      def inherit_variables
        controller.instance_variables.select {|m| m =~ /^@[a-z]/ }.each do |name|
          instance_variable_set name, controller.instance_variable_get(name)
        end
      end
      
    public
      def show
        render partial: "show"
      end
      
      def new
        render partial: "form"
      end
      
      def create
        render partial: "form"
      end
      
      def edit
        render partial: "form"
      end
      
      def update
        render partial: "form"
      end
  end
  
  module ViewCell
    extend ActiveSupport::Concern
    
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
      
    public
      def index
        render
      end
  end
end
