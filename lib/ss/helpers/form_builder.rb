# coding: utf-8
module SS::Helpers
  class FormBuilder < ActionView::Helpers::FormBuilder
    public
      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        return super if method !~ /\[/
        
        object_method = "#{@object_name}[" + method.sub("[", "][")
        if method =~ /\[\]$/
          checked = array_value(method).include?(checked_value)
          options[:id] ||= object_method.gsub(/\W+/, "_") + "#{checked_value}"
        else
          checked = array_value(method).present?
        end
        
        @template.check_box_tag(object_method, checked_value, checked, options)
      end
    
    private
      def array_value(method)
        item = @template.instance_variable_get(:"@#{@object_name}")
        code = method.sub(/\[\]$/, "").gsub(/\[(\D.*?)\]/, '["\\1"]')
        
        if method =~ /\[\]$/
          value = eval("item.#{code}") || []
        else
          value = eval("item.#{code}")
        end
      end
  end
end
