# coding: utf-8
module Storage
  class Initializer
    type = :local
    
    if type == :local
      Storage.__send__(:include, Storage::Adapter::LocalFile)
    end
  end
end
