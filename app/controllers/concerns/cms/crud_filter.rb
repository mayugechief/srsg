# coding: utf-8
module Cms::CrudFilter
  extend ActiveSupport::Concern
  include SS::CrudFilter
  
  included do
    menu_view "ss/crud/menu"
  end
end
