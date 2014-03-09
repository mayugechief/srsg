# coding: utf-8
module Cms::NodeFilter::EditCell
  extend ActiveSupport::Concern
  include SS::CrudFilter
  
  included do
    helper ApplicationHelper
    cattr_accessor :model_class
    before_action :inherit_variables
    before_action :set_model
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
    
    def append_view_paths
      append_view_path "app/views/ss/crud"
    end
    
    def inherit_variables
      controller.instance_variables.select {|m| m =~ /^@[a-z]/ }.each do |name|
        instance_variable_set name, controller.instance_variable_get(name)
      end
      @base = @item
    end
    
    def set_model
      @model = self.class.model_class
      controller.instance_variable_set :@model, @model
    end
    
    def set_item
      @item = @base.new_record? ? @model.new(pre_params) : @model.find(@base.id)
      @item.attributes = { route: @base.route }.merge(@fix_params)
    end
    
    def fix_params
      { site_id: @cur_site.id, cur_node: @cur_node }.merge(@fix_params)
    end
    
    def pre_params
      {}
    end
    
    def get_params
      params.require(:item).permit(@model.permitted_fields).merge(fix_params)
    end
    
  public
    def show
      render
    end
    
    def new
      render
    end
    
    def create
      @item.attributes = get_params
      @item.save ? @item : render(file: :new)
    end
    
    def edit
      render
    end
    
    def update
      @item.attributes = get_params
      @item.update ? @item : render(file: :edit)
    end
    
    def delete
      render
    end
    
    def destroy
      @item.destroy ? @item : render(file: :delete)
    end
end
