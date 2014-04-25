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
  
  def lang(name, opts = {})
    opts[:scope] = [:views, :general] if name !~ /\./ && !opts[:scope]
    hn = I18n.translate name, opts.merge(default: "unk")
    return hn if hn != "unk"
    
    hn = I18n.translate name.to_s.sub(/.*\./, ""), scope: [:views, :general], default: "unk"
    (hn == "unk") ? name.to_s.humanize : hn
  end
  
  def link_to(*args)
    if args[0].class == Symbol
      hn = I18n.translate args[0], scope: [:views, :links], default: "unk"
      args[0] = (hn == "unk") ? lang(args[0]) : hn
    end
    super *args
  end
end
