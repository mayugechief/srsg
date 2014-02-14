SS::Application.configure do

  # Code loading.
  config.cache_classes = false
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Asset pipeline.
  config.assets.debug = true
  config.assets.compress = false
  config.sass.debug_info = true
  
  # Logger
  logger = Logger.new("#{Rails.root}/log/development.log")
  logger.level = Logger::WARN
  # logger.level = Logger::DEBUG
  
  config.logger = logger
  config.log_level = :warn
  # config.log_level = :debug
  
  # Moped.logger = logger.dup
end
