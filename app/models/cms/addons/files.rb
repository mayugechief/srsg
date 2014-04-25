# coding: utf-8
module Cms::Addons
  module Files
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      attr_accessor :cur_user
      
      embeds_ids :files, class_name: "SS::File"
      permit_params file_ids: []
      
      before_save :save_files
      after_destroy :destroy_files
    end
    
    def save_files
      ids = []
      files.each do |file|
        next if @cur_user && @cur_user.id != file.user_id
        file.update_attribute(:model, model_name.i18n_key)
        ids << file.id
      end
      
      (file_ids_was.to_a - ids).each do |id|
        file = SS::File.where(id: id).first
        file.destroy if file
      end
      
      self.file_ids = ids
    end
    
    def destroy_files
      files.destroy_all
    end
  end
end
