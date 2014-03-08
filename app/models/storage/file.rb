# coding: utf-8
class Storage::File
  include Mongoid::Document
  
  field :filename, type: String
  field :size, type: Integer
  field :content_type, type: String
  field :created, type: DateTime, default: -> { Time.now }
  field :updated, type: DateTime, default: -> { Time.now }
end
