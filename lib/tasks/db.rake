# coding: utf-8
namespace :db do
  
  namespace :user do
    task :create => :environment do
      puts "Create user ..."
      item = SS::User.create eval(ENV["data"])
      puts "  " + (item.errors.size == 0 ? item.name : item.errors.full_messages.join("\n  "))
    end
  end
  
  namespace :site do
    task :create => :environment do
      puts "Create site ..."
      item = SS::Site.create eval(ENV["data"])
      puts "  " + (item.errors.size == 0 ? item.name : item.errors.full_messages.join("\n  "))
    end
  end
  
end
