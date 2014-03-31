# coding: utf-8
module Sns::CrudFilter
  extend ActiveSupport::Concern
  
  included do
    include SS::CrudFilter
    
    menu_view "ss/crud/menu"
  end
end
