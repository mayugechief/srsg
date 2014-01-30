# coding: utf-8
class Storage::File
  include Mongoid::Document
  
  field :filename, type: String
  field :size, type: Integer
  field :content_type, type: String
  field :created, type: Datetime, default: -> { Time.now }
  field :updated, type: Datetime, default: -> { Time.now }
  
end