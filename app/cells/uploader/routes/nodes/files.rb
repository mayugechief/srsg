# coding: utf-8
module Uploader::Routes::Nodes::Files
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    model ::Cms::Node
  end
end