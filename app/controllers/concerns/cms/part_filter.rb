# coding: utf-8
module Cms::PartFilter
  extend ActiveSupport::Concern
  
  included do
    include Cms::CrudFilter
    include Base
  end
  
  module Base
    extend ActiveSupport::Concern
    
    private
      def append_view_paths
        append_view_path ["app/views/cms/parts", "app/views/ss/crud"]
      end
      
      def render_route
        @item.route = params[:route] if params[:route].present?
        
        params.merge! vars: { cur_site: @cur_site, cur_node: @cur_node, base: @item }
        params.merge! fix_params: fix_params
        
        cell = "#{@item.route.sub('/', '/part/')}/edit"
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
  
  module EditCell
    extend ActiveSupport::Concern
    
    included do
      include SS::CrudFilter
      include Cms::NodeFilter::EditCell::Base 
      #include Base
    end
    
    module Base
    end
  end
  
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
