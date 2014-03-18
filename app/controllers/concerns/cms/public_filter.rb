# coding: utf-8
module Cms::PublicFilter
  extend ActiveSupport::Concern
  
  private
    def replace_preview_paths(body)
      body = body.gsub(/href="\//, "href=\"#{cms_preview_path}/")
    end
    
    def combine_layout(page)
      head = page.match(/<header.*?<\/header>/m).to_s
      site_name = head.sub(/.* id="ss-site-name".*?>(.*?)<.*/m, '\\1')
      page_name = head.sub(/.* id="ss-page-name".*?>(.*?)<.*/m, '\\1')
      
      if @cur_layout
        data = ActiveSupport::JSON.decode(@cur_layout.render_json)
        
        body = page.sub(/.*?<article.*?(<script.*)<\/article>.*/m, '\\1')
        body = data["body"].sub(/<\/ yield \/>/, body)
        
        page = page.sub("</head>", "#{data['head']}</head>")
        page = page.sub(/<body.*<\/body>/m, body)
        
        page = page.gsub(/<!-- part .*? -->.*?<!-- \/part -->/m) do |m|
          path = m.sub(/<!-- part (.*?) -->.*/m, '\\1')
          route_part(path)
        end
        
        page = page.sub(/( id="ss-site-name".*?>)[^<]+/, "\\1#{site_name}")
        page = page.sub(/( id="ss-page-name".*?>)[^<]+/, "\\1#{page_name}")
      end
      
      pos  = "position: absolute; top: 2px; left: 0px; padding-left: 2px;"
      css  = "#{pos}; color: #070; border-bottom: 3px solid #282;"
      mark = %Q[<div style="#{css}">Preview</div>]
      page = page.sub("</body>", "#{mark}</body>")
    end
    
    def convert_mobile(body)
      body.gsub!(/<(\/?)(header|nav|footer)( |>)/, '<\\1div\\3')
      body.gsub!(/<link[ >].*?\/>/, "")
      body.gsub!(/<script[ >].*?<\/script>/, "")
      body.gsub!(/<body/, '<body style="font-size: 80%;"')
      body.gsub!(/<(h\d)(.*?)>/, '<div\\2 class="\\1">\\1: ')
      body.gsub!(/<\/(h\d)>/, '</div>')
      body.gsub!(/( *\n+ *)+/, "\n")
      
      body
    end
end
