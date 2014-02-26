# coding: utf-8
class Uploader::Node::Files
  
  class EditCell < Cell::Rails
    include Cms::NodeFilter::EditCell
    
    model ::Cms::Node
  end
end