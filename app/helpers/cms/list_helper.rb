# coding: utf-8
module Cms::ListHelper
  def render_node_list(&block)
    cur_item = @cur_page || @cur_part || @cur_node
    
    h  = []
    h << cur_item.upper_html.html_safe if cur_item.upper_html.present?
    if block_given?
      h << capture(&block)
    else
      h << render(file: "app/cells/cms/addon/node_list/view/index", locals: { cur_item: cur_item })
    end
    h << cur_item.lower_html.html_safe if cur_item.lower_html.present?
    
    h.join.html_safe
  end

  def render_page_list(&block)
    cur_item = @cur_page || @cur_part || @cur_node
    
    h  = []
    h << cur_item.upper_html.html_safe if cur_item.upper_html.present?
    if block_given?
      h << capture(&block)
    else
      h << render(file: "app/cells/cms/addon/page_list/view/index", locals: { cur_item: cur_item })
    end
    h << cur_item.lower_html.html_safe if cur_item.lower_html.present?
    
    h.join.html_safe
  end
end
