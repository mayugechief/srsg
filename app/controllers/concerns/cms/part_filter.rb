# coding: utf-8
module Cms::PartFilter
  module Controller
    private
      def append_view_paths
        append_view_path ["app/views/cms/parts", "app/views/ss/crud"]
      end
      
      def render_route
        @item.route = params[:route] if params[:route].present?
        @fix_params = fix_params
        
        cell = "#{@item.route.sub('/', '/routes/parts/')}/edit"
        resp = render_cell cell, params[:action]
        
        if resp.is_a?(String)
          @resp = resp
        else
          @item = resp
        end
      end
      
      def redirect_url
        nil
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
    include Cms::NodeFilter::EditCell 
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
