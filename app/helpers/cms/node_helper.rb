# coding: utf-8
module Cms::NodeHelper
  def node_navi(opts = {}, &block)
    h  = []
    
    if block_given?
      h << capture(&block)
    end
    
    h << render(partial: "node/main/node_navi")
    h << render(partial: "node/main/modules")
    h.join.html_safe
  end
end
