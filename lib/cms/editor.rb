# coding: utf-8
module Cms::Editor
  
  class << self
    
    cattr_accessor(:plugins) { [] }
    #@@single_plugins
    #@@multiple_plugins
    
    public
      def addon(cell, opts = {})
        name = cell.titleize
        path = cell.sub('/', '/editor/')
        plugins << Plugin.new(name, path, opts)
      end
  end
  
  class Plugin
    
    attr_accessor :name, :cell, :opts
    
    private
      def initialize(name, cell, opts = {})
        self.name = name
        self.cell = cell
        self.opts = opts || {}
      end
  end
end
