require File.expand_path('../boot', __FILE__)

# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(:default, Rails.env)

module SS
  
  class Application < Rails::Application
    I18n.enforce_available_locales = true
    
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    # config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/validators"
    
    Dir.glob("#{config.root}/config/routes/*/*.rb").sort.each do |f|
      config.paths["config/routes.rb"] << f
    end
    config.paths["config/routes.rb"] << "#{config.root}/config/routes_end.rb"
  end
end

def dump(*args)
  SS::Debug.dump(*args) #::File.open("#{Rails.root}/log/dump.log", "a") {|f| f.puts args.inspect }
end
