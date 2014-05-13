# coding: utf-8
module Cms::ReleaseFilter::Layout
  extend ActiveSupport::Concern
  include Cms::ReleaseFilter
  
  private
    def find_layout(path)
      layout = Cms::Layout.find_by(site_id: @cur_site, filename: path) rescue nil
      return nil unless layout
      @preview || layout.public? ? layout : nil
    end
    
    def render_layout(layout)
      @cur_layout = layout
      respond_to do |format|
        format.html { layout.render_html }
        format.json { layout.render_json }
      end
    end
    
    def send_layout(body)
      respond_to do |format|
        format.html do
          body.sub!(/(<[^>]+ id="ss-site-name".*?>)[^<]+/, "\\1#{@cur_site.name}")
          body.sub!(/(<[^>]+ id="ss-page-name".*?>)[^<]+/, "\\1Layout")
          render inline: body
        end
        format.json { render json: body }
      end
    end
    
    def generate_layout(layout)
      return unless SS.config.cms.serve_static_layouts
      
      html = layout.render_html
      keep = html.to_s == File.read(layout.path).to_s rescue false
      
      Fs.write layout.path, html
      Fs.write layout.json_path, layout.render_json
    end
    
    def find_part(path)
      part = Cms::Part.find_by site_id: @cur_site, filename: path rescue nil
      return unless part
      @preview || part.public?  ? part : nil
    end
    
    def render_part(part, path = @path)
      return part.html if part.route == "cms/frees"
      cell = recognize_path "/.#{@cur_site.host}/parts/#{part.route}.#{path.sub(/.*\./, '')}"
      return unless cell
      @cur_part = part
      render_cell part.route.sub(/\/.*/, "/#{cell[:controller]}/view"), cell[:action]
    end
    
    def send_part(body)
      respond_to do |format|
        format.html { render inline: body, layout: (request.xhr? ? false : "cms/part") }
        format.json { render json: body.to_json }
      end
    end
    
    def embed_layout(body, layout, opts = {})
      head = body.match(/<header.*?<\/header>/m).to_s
      site_name = head =~ /<[^>]+ id="ss-site-name".*?>(.*?)</m ? $1 : nil
      page_name = head =~ /<[^>]+ id="ss-page-name".*?>(.*?)</m ? $1 : nil
      
      if layout
        @request_url = "/#{@path}"
        layout.parts_condition = opts[:part_condition]
        data = ActiveSupport::JSON.decode(layout.render_json)
        
        main = body =~ /<!-- yield -->(.*)<!-- \/yield -->/m ? $1 : body
        main = data["body"].sub(/<\/ yield \/>/, main)
        
        body.sub!("</head>", "#{data['head']}</head>")
        body.sub!(/<body.*<\/body>/m, main)
        
        body.gsub!(/<a( [^>]*?class="ss-part"[^>]*?)>.*?<\/a>/m) do |m|
          path = (m =~ / href=/) ? m.sub(/.* href="(.*?)".*/, '\\1').sub(/^\//, '') : nil
          part = find_part(path)
          part ? render_part(part, path) : m
        end
        
        body.sub!(/(<[^>]+ id="ss-site-name".*?>)[^<]+/, "\\1#{site_name}")
        body.sub!(/(<[^>]+ id="ss-page-name".*?>)[^<]+/, "\\1#{page_name}")
      end
      
      body
    end
end
