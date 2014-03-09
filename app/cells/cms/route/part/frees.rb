# coding: utf-8
module Cms::Route::Part::Frees
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    model Cms::Part
  end
end