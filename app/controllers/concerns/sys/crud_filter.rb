# coding: utf-8
module Sys::CrudFilter
  extend ActiveSupport::Concern
  
  included do
    include SS::CrudFilter
  end
end
