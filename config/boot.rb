# Set up default environment.
begin
  require "yaml"
  default_env = YAML.load_file File.expand_path('../../config/environment.yml', __FILE__)
  ENV['RAILS_ENV'] ||= default_env["RAILS_ENV"]
rescue LoadError
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
