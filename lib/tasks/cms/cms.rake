# coding: utf-8
namespace :cms do
  
  namespace :layout do
    task :publish => :environment  do
      puts "Publish layouts ..."
      Cms::Layout.all.each do |item|
        puts "  #{item.path}"
        Storage.write item.json_path, item.render_json
      end
      puts "Completed."
    end
  end
  
  # namespace :piece do
    # task :publish => :environment  do
      # puts "Publish layouts ..."
      # Cms::Piece.all.each do |item|
        # puts "  #{item.path}"
        # Storage.write item.path, item.render_html
      # end
      # puts "Completed."
    # end
  # end
  
end
