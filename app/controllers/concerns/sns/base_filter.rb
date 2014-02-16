# coding: utf-8
module Sns::BaseFilter
  extend ActiveSupport::Concern
  
  included do
    include SS::BaseFilter
  end
end
