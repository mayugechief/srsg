# coding: utf-8
module SS::Extensions
  
  module Sequence
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      def sequence_field(name)
        fields = instance_variable_get(:@_sequenced_fields) || []
        instance_variable_set(:@_sequenced_fields, fields << name)
        before_save :set_sequence
      end
    end
    
    public
      def next_sequence(name)
        SS::Sequence.next_sequence collection_name, name
      end
      
      def unset_sequence(name)
        SS::Sequence.unset_sequence collection_name, name
      end
      
    private
      def set_sequence
        self.class.instance_variable_get(:@_sequenced_fields).each do |name|
          next if read_attribute(name).to_s =~ /^[1-9]\d*$/
          write_attribute name, next_sequence(name)
        end
      end
  end
  
  class ObjectIds < Array
  
    def mongoize
      self.to_a
    end
    
    class << self
      
      def demongoize(object)
        self.new(object.to_a)
      end
      
      def mongoize(object)
        case object
        when self.class then object.mongoize
        when String then []
        when Array
          ids = object.reject {|m| m.blank? }.uniq.map {|m| m.to_i }
          #ids = object.reject {|m| m.blank? }.uniq.map {|m| BSON::ObjectId.from_string(m) }
          self.new(ids).mongoize
        else object
        end
      end
      
      def evolve(object)
        case object
        when self.class then object.mongoize
        else object
        end
      end
    end
  end
  
  class Words < Array
  
    def to_s
      join(", ")
    end
    
    def mongoize
      self.to_a
    end
    
    class << self
      
      def demongoize(object)
        self.new(object.to_a)
      end
      
      def mongoize(object)
        case object
        when self.class then object.mongoize
        when String then self.new(object.gsub(/[, 　、]+/, ",").split(",").uniq).mongoize
        else object
        end
      end
      
      def evolve(object)
        case object
        when self.class then object.mongoize
        else object
        end
      end
    end
  end
end
