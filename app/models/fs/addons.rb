# coding: utf-8
module Fs::Addons
  module Files
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      #embeds_ids :files, class_name: "Sns::UserFile"
      permit_params file_ids: []
      
      after_save :save_fs_files
      after_destroy :destroy_fs_files
    end
    
    def file_ids
      @file_ids || []
    end
    
    def file_ids=(ids)
      @file_ids = ids
    end
    
    def files
      Sns::UserFile.
        where(model: self.class.to_s.underscore).
        where(ref_id: id)
    end
    
    def save_fs_files
      file_ids.each do |file_id|
        file = Sns::UserFile.find(file_id) rescue nil
        #TODO: valid user
        next unless file
        
        file.model  = self.class.to_s.underscore
        file.ref_id = id
        file.save
      end
    end
    
    def destroy_fs_files
      files.each {|file| file.destroy }
    end
  end
end
