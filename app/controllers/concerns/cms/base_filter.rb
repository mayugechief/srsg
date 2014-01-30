# coding: utf-8
module Cms::BaseFilter
  extend ActiveSupport::Concern
  
  included do
    before_action :set_site
    before_action :set_node
    crumb ->{ [@cur_site.name, cms_main_path] }
  end
  
  def set_site
    @cur_site = SS::Site.where(host: params[:host]).first
  end
  
  def set_node
    @cur_node = Cms::Node.site_is(@cur_site).where(id: params[:cid]).first
  end
  
  def url_options
    {}.merge(super)
  end
end
