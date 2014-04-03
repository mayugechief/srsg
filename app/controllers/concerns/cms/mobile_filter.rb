# coding: utf-8
module Cms::MobileFilter
  extend ActiveSupport::Concern

  private
    def replace_mobile_paths(body)
      body = body.gsub(/href="\/(?!mobile\/)/, "href=\"/mobile/")
    end
    
    def convert_mobile(body)
      body
    end
end
