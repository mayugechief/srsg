# coding: utf-8
module Cms::CrudFilter
  extend ActiveSupport::Concern
  
  included do
    include SS::CrudFilter
    
    menu_view "ss/crud/menu"
  end
end
