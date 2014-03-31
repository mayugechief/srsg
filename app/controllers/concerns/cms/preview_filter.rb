# coding: utf-8
module Cms::PreviewFilter
  extend ActiveSupport::Concern
  
  private
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
      
      page
    end
    
    def replace_preview_paths(body)
      body = body.gsub(/href="\//, "href=\"#{cms_preview_path}/")
      pos  = "position: absolute; top: 2px; left: 0px; padding-left: 2px;"
      css  = "#{pos}; border-bottom: 2px solid #282; color: #070; font-weight: bold;"
      mark = %Q[<div style="#{css}">Preview</div>]
      body = body.sub("</body>", "#{mark}</body>")
    end
end
