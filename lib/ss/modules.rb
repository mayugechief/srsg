# coding: utf-8
require 'zipruby'
module SS::Modules
  
  module Package
    
    class << self
      
      def zip_dir
        "#{Rails.root}/vendor/modules"
      end
      
      def module_dirs
        [
          "app/assets/images",
          "app/assets/javascripts",
          "app/assets/stylesheets",
          "app/cells",
          "app/controllers",
          "app/controllers/concerns",
          "app/helpers",
          "app/mailers",
          "app/models",
          "app/models/concerns",
          "app/views",
          "app/views/layouts",
          "config/initializers",
          "config/locales",
          "config/routes",
          "db",
          "doc",
          "lib",
          "lib/tasks/",
        ]
      end
      
      def valid_name(name, ver = nil)
        mod = name.gsub("-", "_")
        raise "invalid module name" if mod !~ /^\w+$/
        raise "invalid module version" if ver.to_s =~ /[^\w\.]/
        
        name += "-#{ver}" if ver.present?
        [mod, name, "#{zip_dir}/#{name}.zip"]
      end
      
      def make(name, ver = nil)
        mod, name, zip = valid_name name, ver
        
        Dir.chdir(Rails.root)
        Zip::Archive.open("#{zip}.tmp", Zip::CREATE) do |ar|
          module_dirs.each do |dir|
            ar.add_dir "#{dir}/#{mod}" if File.exists? "#{dir}/#{mod}"
            Dir.glob("#{dir}/#{mod}{/**/*,.*}") do |file|
              if File.directory?(file)
                ar.add_dir(file)
                puts "  #{file}/"
                next
              end
              ar.add_file(file, file)
              puts "  #{file}"
            end
          end
        end
        
        raise "No such module: #{mod}" if !File.exists?("#{zip}.tmp")
        puts "  => #{zip}"
        FileUtils.mv "#{zip}.tmp", zip
      end
      
      def install(name, ver = nil)
        mod, name, zip = valid_name name, ver
        puts "#{zip}"
        
        Dir.chdir(Rails.root)
        module_dirs.each {|dir| raise "module exists: #{dir}/#{mod}" if File.exists?("#{dir}/#{mod}") }
        
        Zip::Archive.open(zip) do |ar|
          entry_names = ar.map do |f|
            if f.directory?
              FileUtils.mkdir_p(f.name) if !File.exists?(f.name)
              puts "  #{f.name}"
              next
            end
            File.binwrite(f.name, f.read)
            puts "  #{f.name}"
          end
        end
      end
      
      def uninstall(name)
        #raise "cannot uninstall core system" if name =~ /^ss$/
        mod, name, zip = valid_name name
        
        Dir.chdir(Rails.root)
        module_dirs.each do |dir|
          Dir.glob("#{dir}/#{mod}{/,/**/*,.*}").each do |file|
            FileUtils.rm_r(file) if File.exists?(file)
            puts "  #{file}"
          end
        end
      end
    end
  end
end
