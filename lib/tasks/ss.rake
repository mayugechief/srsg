# coding: utf-8
namespace :ss do
  namespace :mod do
    task :make => :environment  do
      puts "Make package ..."
      zip = SS::Modules::Package.make ENV["name"], ENV["v"]
    end
    
    task :install => :environment  do
      puts "Install module ..."
      SS::Modules::Package.install ENV["name"], ENV["v"]
    end
    
    task :uninstall => :environment do
      puts "Uninstall module ..."
      SS::Modules::Package.uninstall ENV["name"]
    end
    
    task :update => :environment do
      mod, name, zip = SS::Modules::Package.valid_name ENV["name"], ENV["v"]
      raise "No such file: #{zip}" if !File.exists?(zip)
      Rake::Task["ss:mod:uninstall"].invoke
      Rake::Task["ss:mod:install"].invoke
    end
  end
end
