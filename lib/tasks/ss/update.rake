# coding: utf-8
namespace :ss do
  task :update => :environment  do
    puts "# replace user password"
    
    SS::User.all.each do |item|
      item.password = SS::Crypt.crypt("pass")
      item.save
    end
    
    puts "success"
  end
end
