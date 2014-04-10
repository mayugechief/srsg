# coding: utf-8
namespace :ss do
  task :crypt => :environment  do
    puts "Crypt password ..."
    puts SS::Crypt.crypt(ENV["value"])
  end
  
  task :encrypt => :environment  do
    puts "Encrypt password ..."
    puts SS::Crypt.encrypt(ENV["value"])
  end
end
