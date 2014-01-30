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
      
#      def find(args)
#        if args.instance_of?(Fixnum)
#          return find_by id: args
#        elsif args.instance_of?(String)
#          return args =~ /^\d+$/ ? find_by(id: args) : find_by(_id: args)
#        elsif args.instance_of?(Array)
#          return [] if args.size == 0
#          return where(args.first =~ /^\d+$/ ? { :id.in => args } : { :_id.in => args }).to_a
#        end
#        super args
#      end
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
end
