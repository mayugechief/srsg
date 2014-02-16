# coding: utf-8
module Sys::BaseFilter
  extend ActiveSupport::Concern
  
  included do
    include SS::BaseFilter
    before_action { @crumbs <<  [:sys, sys_main_path] }
    before_action :set_crumbs
  end
  
  private
    def set_crumbs
      #
    end
end
