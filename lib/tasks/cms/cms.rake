# coding: utf-8
namespace :cms do
  namespace :layout do
    task :publish => :environment  do
      puts "Publish layouts ..."
      Cms::Layout.all.each do |item|
        puts "  #{item.path}"
        Fs.write item.json_path, item.render_json
      end
      puts "Completed."
    end
  end
  
  # namespace :part do
    # task :publish => :environment  do
      # puts "Publish layouts ..."
      # Cms::Part.all.each do |item|
        # puts "  #{item.path}"
        # Fs.write item.path, item.render_html
      # end
      # puts "Completed."
    # end
  # end
end
