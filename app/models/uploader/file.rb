# coding: utf-8
class Uploader::File
  include ActiveModel::Model
  
  attr_accessor :filename, :size
  
  class << self
    public
      def lang(name)
        name.to_s.gsub(/^_/, "").titleize
      end
  end
end
