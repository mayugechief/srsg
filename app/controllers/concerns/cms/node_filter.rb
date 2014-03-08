# coding: utf-8
module Cms::NodeFilter
  module Controller
    private
      def append_view_paths
        append_view_path ["app/views/cms/nodes", "app/views/ss/crud"]
      end
      
      def render_route
        @item.route = params[:route] if params[:route].present?
        @fix_params = fix_params
        
        cell = "#{@item.route.sub('/', '/routes/nodes/')}/edit"
        resp = render_cell cell, params[:action]
        
        if resp.is_a?(String)
          @resp = resp
        else
          @item = resp
        end
      end
      
      def redirect_url
        if params[:action] == "destroy"
          return cms_nodes_path unless @item.parent
          diff = @item.route.split("/")[0] != @item.parent.route.split("/")[0]
          return node_nodes_path(cid: @item.parent) if diff
          { controller: params[:controller].split("/")[0].pluralize, cid: @item.parent }
        else
          diff = @item.route.split("/")[0] != params[:controller].split("/")[0]
          diff ? { action: :show, id: @item } : nil
        end
      end
      
    public
      def show
        render_route
      end
      
      def new
        @item = @model.new pre_params.merge(fix_params)
        render_route
      end
      
      def create
        @item = @model.new get_params
        render_route
        render_create @resp.blank?, location: redirect_url
      end
      
      def edit
        render_route
      end
      
      def update
        @item.attributes = get_params
        render_route
        render_update @resp.blank?, location: redirect_url
      end
      
      def delete
        render_route
      end
      
      def destroy
        render_route
        render_destroy @resp.blank?, location: redirect_url
      end
  end
  
  extend ActiveSupport::Concern
  include Cms::CrudFilter
  include Controller
  
  module EditCell
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
  end
end
