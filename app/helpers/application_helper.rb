# coding: utf-8
module ApplicationHelper

  def tryb(&block)
    begin
      block.call
    rescue NoMethodError
      nil
    end
  end
  
  def br(str)
    h(str.to_s).gsub(/(\r\n?)|(\n)/, "<br />").html_safe
  end
  
  def snip(str, opt = {})
    len = opt[:length] || 80
    "#{str.to_s[0..len-1]}#{str.to_s.size > len ? ".." : ""}".html_safe
  end
  
  def link_to(*args)
    args[0] = args[0].to_s.humanize if args[0].class == Symbol
    super *args
  end
end
