# coding: utf-8
class Uploader::Node::Files
  
  class ConfigCell < Cell::Rails
    include Cms::NodeFilter::Config
    
    model ::Cms::Node
  end
end