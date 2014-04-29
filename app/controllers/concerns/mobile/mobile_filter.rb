# coding: utf-8
module Mobile::MobileFilter
  extend ActiveSupport::Concern

  private
    def convert_mobile(body)
      body = Mobile::HtmlConvertor.new(body)
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
      
      dir = "#{@cur_site.path}/css"
      if Fs.exists?("#{dir}/mobile.css") || Fs.exists?("#{dir}/mobile.scss")
        css = "/css/mobile.css"
      else
        css = "/stylesheets/cms/mobile.css"
      end
      body.sub!("</head>", %Q[<link rel="stylesheet" href="#{css}" /></head>])
      
      body.to_s
    end
end
