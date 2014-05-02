# coding: utf-8
module Acl
  class Initializer
    Acl::Entry.permit_options = [
      "admin",
      "manage_private_nodes",
      "manage_private_pages",
      "manage_private_layouts",
      "manage_private_parts"
    ]
    
    SS::User.addon "acl/entries"
    
    Cms::Node.addon "acl/owners"
    Cms::Node.acl_entry_name = "nodes"
    
    Cms::Page.addon "acl/owners"
    Cms::Page.acl_entry_name = "pages"
    
    Cms::Layout.addon "acl/owners"
    Cms::Layout.acl_entry_name = "layouts"
    
    Cms::Part.addon "acl/owners"
    Cms::Part.acl_entry_name = "parts"
    
    Node::Node.addon "acl/owners"
    Node::Node.acl_entry_name = "nodes"
    
    Node::Node::Node.addon "acl/owners"
    Node::Node::Node.acl_entry_name = "nodes"
    
    Cms::Node::Model.include Acl::Addons::Owners
#    Cms::Node::Model.acl_entry_name = "nodes"
  end
end
