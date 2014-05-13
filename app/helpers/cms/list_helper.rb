# coding: utf-8
module Cms::ListHelper
  def render_node_list(&block)
    cur_item = @cur_part || @cur_node
    
    h  = []
    h << cur_item.upper_html.html_safe if cur_item.upper_html.present?
    if block_given?
      h << capture(&block)
    else
      @items.each do |item|
        if cur_item.loop_html.present?
          h << cur_item.render_loop_html(item)
        else
          ih  = []
          ih << '<article class="item-#{class}">'
          ih << '  <header>'
          ih << '     <h2><a href="#{url}">#{name}</a></h2>'
          ih << '  </header>'
          ih << '</article>'
          
          h  << cur_item.render_loop_html(item, html: ih.join("\n"))
        end
      end
    end
    h << cur_item.lower_html.html_safe if cur_item.lower_html.present?
    
    h.join.html_safe
  end

  def render_page_list(&block)
    cur_item = @cur_part || @cur_node
    
    h  = []
    h << cur_item.upper_html.html_safe if cur_item.upper_html.present?
    if block_given?
      h << capture(&block)
    else
      @items.each do |item|
        if cur_item.loop_html.present?
          h << cur_item.render_loop_html(item)
        else
          ih  = []
          ih << '<article class="item-#{class} #{new}">'
          ih << '  <header>'
          ih << '    <time datetime="#{date.iso}">#{date.long}</time>'
          ih << '     <h2><a href="#{url}">#{name}</a></h2>'
          ih << '  </header>'
          ih << '</article>'
          
          h  << cur_item.render_loop_html(item, html: ih.join("\n"))
        end
      end
    end
    h << cur_item.lower_html.html_safe if cur_item.lower_html.present?
    
    h.join("\n").html_safe
  end
end
