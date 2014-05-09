# encoding: utf-8
module SS::Config
  cattr_accessor(:data) { {} }
  
  def SS.config
    SS::Config
  end
  
  class << self
    def method_missing(name, *args, &block)
      return super if data[name]
      
      file  = "#{Rails.root}/config/#{name}.yml"
      conf  = File.exists?(file) ? YAML.load_file(file)[Rails.env] : {}
      klass = "#{name.to_s.camelize}::Config".constantize rescue nil
      conf  = klass.default_values.merge(conf) if klass
      
      define_singleton_method(name) { data[name] = OpenStruct.new(conf) }
      send(name)
    end
  end
end
