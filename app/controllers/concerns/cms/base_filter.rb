# coding: utf-8
module Cms::BaseFilter
  extend ActiveSupport::Concern
  include SS::BaseFilter
  
  included do
    before_action :set_site
    before_action :set_node
    before_action :set_crumbs
  end
  
  private
    def set_site
      @cur_site = SS::Site.find_by host: params[:host]
      @crumbs << [@cur_site.name, cms_main_path]
    end
    
    def set_node
      return unless params[:cid]
      @cur_node = Cms::Node.site(@cur_site).find params[:cid]
      @cur_node.parents.each {|node| @crumbs << [node.name, node_nodes_path(node)] }
      @crumbs << [@cur_node.name, node_nodes_path(@cur_node)]
    end
    
    def set_crumbs
      #
    end
    
  public
    def url_options
      {}.merge(super)
    end
end
