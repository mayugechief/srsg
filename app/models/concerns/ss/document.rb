# coding: utf-8
module SS::Document
  extend ActiveSupport::Concern
  extend SS::Translation
  include Mongoid::Document
  include SS::Fields::Sequencer
  
  included do
    field :created, type: DateTime, default: -> { Time.now }
    field :updated, type: DateTime, default: -> { Time.now }
    before_save :set_updated
  end
  
  module ClassMethods
    def lang(*args)
      human_attribute_name *args
    end
    
    def seqid(name = :id, opts = {})
      sequence_field name
      
      if name == :id
        replace_field "_id", Integer
        use_id_field if opts[:field] == true
      end
      field name, type: Integer
    end
    
    def use_id_field(name)
      aliased_fields.delete(name.to_s)
      define_method(name) { @attributes[name.to_s] }
      define_method("#{name}=") {|val| @attributes[name.to_s] = val }
    end
    
    def embeds_ids(name, opts = {})
      store = opts[:store_as] || "#{name.to_s.singularize}_ids"
      field store, type: SS::Extensions::ObjectIds, default: []
      define_method(name) { opts[:class_name].constantize.where :_id.in => send(store) }
    end
    
    def permitted_fields #TODO:
      keys = fields.keys
      fields.each {|k, f| keys << { k => [] } if f.type <= Array }
      keys
    end
    
    def lookup_addons
      self.ancestors.select { |x| x.respond_to?(:addon_name) }
    end
    
    def addons
      return @_addons if @_addons
      @_addons = lookup_addons.map {|m| m.addon_name }
    end
  end
  
  private
    def set_updated
      return true if !changed?
      self.updated = Time.now
    end
end
