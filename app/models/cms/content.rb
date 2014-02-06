# coding: utf-8
class Cms::Content
  include Cms::Node::Base
  
  default_scope where type: "main"
  
  @@modules = []
  
  def self.add_module(name)
    @@modules << [name.to_s.humanize, name]
  end
  
  def self.modules
    @@modules
  end
end
