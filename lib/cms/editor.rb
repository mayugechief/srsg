# coding: utf-8
module Cms::Editor
  
  class << self
    
    @@plugins          = []
    @@single_plugins   = []
    @@multiple_plugins = []
    
    def plugins
      @@plugins
    end
    
    def single_plugins
      @@single_plugins
    end
    
    def multiple_plugins
      @@multiple_plugins
    end
    
    def namespace(ns, &block)
      @@ns = ns
      instance_exec(&block) if block_given?
      @@ns = nil
    end
    
    def model(cls)
      #require cls
    end
    
    def plugin(cell, opts = {}, &block)
      @@plugins << (plugin = Plugin.new "#{@@ns}/editor/#{cell}", opts)
      opts[:multiple] ? @@multiple_plugins << plugin : @@single_plugins << plugin
    end
  end
  
  class Plugin
    attr_accessor :name, :cell, :opts
    
    def initialize(cell, opts = {})
      self.cell = cell
      self.name = cell.sub(/.*\//, "").humanize #TODO: locales
      self.opts = opts || {}
    end
  end
end
