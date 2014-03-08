# coding: utf-8
module Cms::Routes::Parts::Frees
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Cms::Part
  end
end