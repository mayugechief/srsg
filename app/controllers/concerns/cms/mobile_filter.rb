# coding: utf-8
module Cms::MobileFilter
  extend ActiveSupport::Concern

  private
    def replace_mobile_paths(body)
      body = body.gsub(/href="\/(?!mobile\/)/, "href=\"/mobile/")
    end
    
    def convert_mobile(body)
      body = Cms::Mobile::Convertor.new(body)
      body.downcase_tags!
      body.remove_comments!
      body.remove_cdata_sections!
      body.remove_other_namespace_tags!
      body.remove_convert_tags!
      body.strip_convert_tags!
      body.gsub_convert_tags!
      body.gsub_img!
      body.gsub_q!
      body.gsub_wbr!
      body.gsub_br!
      body
    end
end
