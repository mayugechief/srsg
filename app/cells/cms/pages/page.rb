# coding: utf-8
module Cms::Pages::Page
  class ViewCell < Cell::Rails
    include Cms::PageFilter::ViewCell
  end
end
