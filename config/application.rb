require File.expand_path('../boot', __FILE__)

# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(:default, Rails.env)

module SS
  class Application < Rails::Application
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/validators"
    
    I18n.enforce_available_locales = true
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    
    [:ss, :sys, :cms].each do |name|
      config.i18n.load_path += Dir["#{config.root}/config/locales/#{name}/*.{rb,yml}"]
    end
    Dir["#{config.root}/config/locales/*/*.{rb,yml}"].each do |file|
      config.i18n.load_path << file unless config.i18n.load_path.index(file)
    end
    
    [:sys, :sns, :cms, :node].each do |name|
      config.paths["config/routes.rb"] << "#{config.root}/config/routes/#{name}/routes.rb"
    end
    Dir["#{config.root}/config/routes/*/routes.rb"].sort.each do |file|
      config.paths["config/routes.rb"] << file
    end
    Dir["#{config.root}/config/routes/*/routes_end.rb"].sort.each do |file|
      config.paths["config/routes.rb"] << file
    end
  end
end

def dump(*args)
  SS::Debug.dump(*args) #::File.open("#{Rails.root}/log/dump.log", "a") {|f| f.puts args.inspect }
end
