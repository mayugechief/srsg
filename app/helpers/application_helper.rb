# coding: utf-8
module ApplicationHelper
  def tryb(&block)
    begin
      block.call
    rescue NoMethodError
      nil
    end
  end
  
  def t(key, opts = {})
    opts[:scope]   = [:base] if key !~ /\./ && !opts[:scope]
    dump opts
    I18n.translate key, opts.merge(default: key.to_s.humanize)
  end
  
  def br(str)
    h(str.to_s).gsub(/(\r\n?)|(\n)/, "<br />").html_safe
  end
  
  def snip(str, opt = {})
    len = opt[:length] || 80
    "#{str.to_s[0..len-1]}#{str.to_s.size > len ? ".." : ""}".html_safe
  end
  
  def link_to(*args)
    if args[0].class == Symbol
      hn = I18n.translate args[0], scope: [:views, :links], default: "unk"
      args[0] = (hn == "unk") ? t(args[0]) : hn
    end
    super *args
  end
  
  def jquery(&block)
    javascript_tag do
      "$(function() {\n#{capture(&block)}\n});".html_safe
    end
  end
  
  def coffee(&block)
    javascript_tag do
      CoffeeScript.compile(capture(&block)).html_safe
    end
  end
  
  def code_editor(elem, opts = {})
    mode = opts[:mode]
    if !mode && opts[:filename]
      extname = opts[:filename].sub(/.*\./, "")
      extname = "javascript" if extname == "js"
      mode = extname if File.exists?("#{Rails.root}/public/javascripts/ace/mode-#{extname}.js")
    end
    
    h  = []
    h << javascript_include_tag("ace/mode-#{mode}.js", "data-turbolinks-track" => true) if mode
    h <<  coffee do
      j  = []
      j << %Q[$ ->]
      j << %Q[  editor = $("#{elem}").ace({ theme: "chrome", lang: "#{mode}" })]
      j << %Q[  ace = editor.data("ace").editor.ace]
      
      if opts[:readonly]
        j << %Q[  ace.setReadOnly(true)]
        j << %Q[  h = ace.getSession().getScreenLength() * 16 + ace.renderer.scrollBar.getWidth()]
        j << %Q[  $(ace["container"]).css("line-height", "16px")]
        j << %Q[  $(ace["container"]).height(h + "px")]
        j << %Q[  $(ace["container"]).find(".ace_scrollbar").hide()]
      end
      
      j.join("\n").html_safe
    end
    
    h.join("\n").html_safe
  end
  
  def html_editor(elem, opts = {})
    opts = { extraPlugins: "", removePlugins: "" }.merge(opts)
    
    if opts[:readonly]
      opts[:removePlugins] << ",toolbar"
      opts[:readOnly] = true
      opts.delete :readonly
    end
    opts[:removePlugins] << ",resize"
    opts[:extraPlugins]  << ",autogrow"
    
    h  = []
    h <<  coffee do
      j = []
      j << %Q[$ ->]
      j << %Q[  $("#{elem}").ckeditor #{opts.to_json}]
      
      j.join("\n").html_safe
    end
    
    h.join("\n").html_safe
  end
  
  def scss(&block)
    opts = SS::Application.config.sass
    sass = Sass::Engine.new capture(&block),
      syntax: :scss,
      cache: false,
      style: :compressed,
      debug_info: false,
      load_paths: opts.load_paths[1..-1]
    
    h  = []
    h << "<style>"
    h << sass.render
    h << "</style>"
    h.join("\n").html_safe
  end
end
