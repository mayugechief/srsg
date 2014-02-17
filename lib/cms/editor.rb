# coding: utf-8
module Cms::Editor
  
  class << self
    
    cattr_accessor(:plugins) { [] }
    #@@single_plugins
    #@@multiple_plugins
    
    public
      def addon(cell, opts = {})
        plugins << Plugin.new(cell.sub('/', '/editor/'), opts)
      end
  end
  
  class Plugin
    
    attr_accessor :name, :cell, :opts
    
    private
      def initialize(cell, opts = {})
        self.cell = cell
        self.name = cell.titleize.sub(/.*\//, "")
        self.opts = opts || {}
      end
  end
end
