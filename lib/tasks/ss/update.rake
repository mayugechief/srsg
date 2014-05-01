# coding: utf-8
namespace :ss do
  task :update => :environment  do
    puts "# replace field value: route"
    
    Cms::Node.all.each do |item|
      item.route = item.route.singularize
      item.route = item.route.sub(/^node\//, "cms/")
      item.save
    end
    
    Cms::Page.all.each do |item|
      item.route = item.route.singularize
      item.save
    end
    
    Cms::Part.all.each do |item|
      item.route = item.route.singularize
      item.route = item.route.sub(/^node\//, "cms/")
      item.route = item.route.sub("category/page", "cms/page")
      item.save
    end
    
    puts "success"
  end
end
