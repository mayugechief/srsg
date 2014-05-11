# coding: utf-8
module Mobile::PublicFilter
  extend ActiveSupport::Concern

  def self.prepended(mod)
    mod.include self
  end
  
  included do
    Cms::PublicFilter.filter :mobile
    after_action :render_mobile, if: ->{ @filter == :mobile }
  end
  
  def set_path_with_mobile
    if @path =~ /^#{SS.config.mobile.location}\//
      @path.sub!(/^#{SS.config.mobile.location}\//, "/")
    end
  end
  
  private
    def render_mobile
      body = embed_layout(response.body, { part_condition: { mobile_view: "show"} })
      
      body = Mobile::Convertor.new(body)
      body.convert!
      
      body.gsub!(/href="\/(?!#{SS.config.mobile.directory}\/)/, "href=\"/mobile/")
      body.gsub!(/<span .*?id="ss-(small|medium|large|kana|pc|mb)".*?>.*?<\/span>/, "")
      
      dir = "#{@cur_site.path}/css"
      css = Fs.exists?("#{dir}/mobile.css") || Fs.exists?("#{dir}/mobile.scss")
      css = css ? "/css/mobile.css" : "/stylesheets/cms/mobile.css"
      body.sub!("</head>", %Q[<link rel="stylesheet" href="#{css}" /></head>])
      
      response.body = body.to_s
    end
end
