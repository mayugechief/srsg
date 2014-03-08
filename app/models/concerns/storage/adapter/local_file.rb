# coding: utf-8
module Storage::Adapter::LocalFile
  extend ActiveSupport::Concern
  
  module ClassMethods
    def exists?(path)
      FileTest.exists? path
    end
    
    def file?(path)
      FileTest.file path
    end
    
    def directory?(path)
      FileTest.directory? path
    end
    
    def read(path)
      ::File.read path
    end
    
    def binread(path)
      ::File.binread path
    end
    
    def write(path, data)
      FileUtils.mkdir_p ::File.dirname(path)
      ::File.write path, data
    end
    
    def binwrite(path, data)
      FileUtils.mkdir_p ::File.dirname(path)
      ::File.binwrite path, data
    end
    
    def stat(path)
      ::File.stat(path)
    end
  end
end
