# coding: utf-8
module EditorHelper
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
    if SS.config.cms.html_editor == "ckeditor"
      html_editor_ckeditor(elem, opts)
    elsif SS.config.cms.html_editor == "tinymce"
      html_editor_tinymce(elem, opts)
    elsif SS.config.cms.html_editor == "wiki"
      html_editor_wiki(elem, opts)
    end
  end
  
  def html_editor_ckeditor(elem, opts = {})
    opts = { extraPlugins: "", removePlugins: "" }.merge(opts)
    
    if opts[:readonly]
      opts[:removePlugins] << ",toolbar"
      opts[:readOnly] = true
      opts.delete :readonly
    end
    opts[:removePlugins] << ",resize"
    opts[:extraPlugins]  << ",autogrow"
    opts[:enterMode] = 2 #BR
    opts[:shiftEnterMode] = 1 #P
    opts[:allowedContent] = true
    
    h  = []
    h <<  coffee do
      j = []
      j << %Q[$ ->]
      j << %Q[  $("#{elem}").ckeditor #{opts.to_json}]
      
      j.join("\n").html_safe
    end
    
    h.join("\n").html_safe
  end
  
  def html_editor_tinymce(elem, opts = {})
    h  = []
    h <<  coffee do
      j = []
      j << %Q[$ ->]
      j << %Q[  tinymce.init]
      j << %Q[    selector: "#{elem}"]
      j << %Q[    language: "ja"]
      
      if opts[:readonly]
      j << %Q[    readonly: true]
      j << %Q[    plugins: \[\]]
      j << %Q[    toolbar: false]
      j << %Q[    menubar: false]
      #j << %Q[    statusbar: false]
      else
      j << %Q[    plugins: \[ ]
      j << %Q[      "advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",]
      j << %Q[      "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",]
      j << %Q[      "save table contextmenu directionality emoticons template paste textcolor"]
      j << %Q[    \],]
      j << %Q[    toolbar: "insertfile undo redo | styleselect | bold italic | forecolor backcolor" +]
      j << %Q[      " | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media"]
      end
      
      j.join("\n").html_safe
    end
    
    h.join("\n").html_safe
  end
  
  def html_editor_wiki(elem, opts = {})
  end
end
