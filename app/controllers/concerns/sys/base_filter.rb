# coding: utf-8
module Sys::BaseFilter
  extend ActiveSupport::Concern
  
  included do
    crumb ->{ [:sys, sys_main_path] }
  end
end
