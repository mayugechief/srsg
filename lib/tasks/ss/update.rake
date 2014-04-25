# coding: utf-8
namespace :ss do
  task :update => :environment  do
    puts "# replace field: tiny to html"
    Cms::Page.where(tiny: /./).each do |item|
      if item["html"].blank? && item["tiny"].present?
        puts "  #{item.id}, #{item.filename}, #{item.name}"
        item["html"] = item["tiny"]
        item.save
      end
    end
    
    puts "# replace field: shortcut"
    Cms::Page.where(shortcut: 1).each do |item|
      puts "  #{item.id}, #{item.filename}, #{item.name}"
      item.shortcut = "show"
      item.save
    end
  end
end
