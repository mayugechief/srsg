# coding: utf-8
module Cms::PartFilter
  
  module Config
    extend ActiveSupport::Concern
    
    included do
      helper ApplicationHelper
      cattr_accessor :model_class
      before_action :inherit_vars
      before_action :set_model
      before_action :set_item
    end
    
    module ClassMethods
      
      def model(cls)
        self.model_class = cls if cls
      end
    end
    
    private
      def inherit_vars
        params[:vars].each {|key, val| instance_variable_set "@#{key}", val }
      end
    
      def set_model
        @model = self.class.model_class
      end
      
      def set_item
        cur_node = @item.cur_node
        route    = @item.route
        
        @item = @item.new_record? ? @model.new(@item.attributes) : @model.find(@item.id)
        @item.attributes = { cur_node: cur_node, route: route }
      end
      
      def set_params(keys = [])
        keys = [keys] if keys.class != Array
        permitted = params.require(:item).permit(@model.permitted_fields + keys)
        permitted = permitted.merge site_id: @cur_site.id
      end
      
    public
      def new; @item end
      def show; @item end
      def edit; @item end
      def delete; @item end
      def destroy; @item end
      
      def create
        @item.attributes = set_params
        @item
      end
      
      def update
        @item.attributes = set_params
        @item
      end
  end
  
  module Base
    extend ActiveSupport::Concern
    
    private
      def render_node_cell
        if params[:item] && params[:item][:route].present?
          @item.route = params[:item][:route]
        end
        if @item.route.present?
          params.merge! vars: { cur_site: @cur_site, cur_node: @cur_node, item: @item }
          @cell = "#{@item.route.sub('/', '/part/')}/config"
          @item = render_cell @cell, params[:action]
        end
      end
      
    public
      def new
        @item = @model.new
        render_node_cell
        render_crud
      end
      
      def show
        render_node_cell
        render_crud
      end
      
      def edit
        render_node_cell
        render_crud
      end
      
      def create
        @item = @model.new set_params
        render_node_cell
        render_create @item.save
      end
      
      def update
        @item.attributes = set_params
        render_node_cell
        render_update @item.update
      end
      
      def destroy
        url = @cur_node ? { controller: :parts, cid: @cur_node } : cms_parts_path
        render_destroy @item.destroy, location: url
      end
  end
end
