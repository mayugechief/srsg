# coding: utf-8
module Cms::Editor
  
  class << self
    
    cattr_accessor(:addons) { [] }
    #@@single_plugins
    #@@multiple_plugins
    
    public
      def addon(mod, name, opts = {})
        cell = "#{mod}/#{name}"
        name = cell.titleize
        path = cell.sub('/', '/editor/')
        addons << Addon.new(name, path, opts)
      end
  end
  
  class Addon
    
    attr_accessor :name, :cell, :opts
    
    private
      def initialize(name, cell, opts = {})
        self.name = name
        self.cell = cell
        self.opts = opts || {}
      end
  end
end
