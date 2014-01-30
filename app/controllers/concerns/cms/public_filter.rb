# coding: utf-8
module Cms::PublicFilter # for cell
  extend ActiveSupport::Concern
  
  included do
    helper ApplicationHelper
    before_action :set_site
  end
  
  private
    def set_site
      @cur_site = params[:cur_site]
      @cur_page = params[:cur_page]
      @cur_node = params[:cur_node]
    end
end
