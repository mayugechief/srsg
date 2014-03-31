# coding: utf-8
class Sns::UserFile
  include SS::Document
  
  store_in collection: "fs.files"
  
  scope :my_model, -> { where model: "sns/user_file" }
  
  attr_accessor :files
  attr_accessor :cur_user, :cur_site, :cur_item
  
  field :state, type: String
  field :model, type: String
  field :ref_id, type: String
  
  field :hunkSize, type: Integer
  field :contentType, type: String
  field :filename, type: String
  field :length, type: Integer
  field :md5, type: String
  field :uploadDate, type: DateTime
  
  permit_params :state, :filename
  
  validates :filename, length: { maximum: 80 }
  
  validate :validate_filename, if: ->{ filename.present? }
  
  alias :name :filename
  
  public
    def file
      Mongoid::GridFs.get(_id)
    end
    
    def basename
      filename.to_s.sub(/.*\//, "")
    end
    
    def extname
      filename.to_s.sub(/.*\W/, "")
    end
    
    def image?
      filename =~ /\.(bmp|gif|jpe?g|png)$/i
    end
    
    def read
      file.data
    end
    
    def destroy
      Mongoid::GridFs.delete(_id)
    end
    
    def save_with_files
      errors.add :files, :blank if files.blank?
      return false unless errors.blank?
      
      files.each do |file|
        attrs = { user_id: @cur_user.id, state: :public, model: self.class.to_s.underscore }
        fs = Mongoid::GridFs.put file, attrs
      end
      return true
    end
    
  private
    def validate_filename
      return errors.add :filename, :blank if filename.blank?
      self.filename = "#{_id}/" + filename.sub(/.*\//, "")
    end
end
