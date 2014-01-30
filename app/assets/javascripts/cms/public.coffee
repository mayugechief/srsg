//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks

class @SS
  @head = ""
  @page = ""
  @href = ""
  
  @load: ->
    SS.layout(layout) if layout = $("#page").attr("data-layout")
    
  @layout: (url) ->
    SS.head = $("head").html()
    SS.page = $("#page").html()
    $("body").html ""
    
    url = url.replace(/\.json$/, ".kana.json") if location.href.match(/\.kana\.html$/)
    $.ajax {
      type: "GET", url: url, dataType: "json"
      #cache: false
      success: (data)->
        if data.href != SS.href
          $("head link").add("head script").remove() if SS.href
          $("head").append data.head
          $("head").append '<link rel="stylesheet" href="/assets/cms/public.css" />' # test
        SS.href = data.href
        $("body").hide();
        $("body").html data.body.replace("</ yield />", SS.page)
        $("body").fadeIn(100);
        
        ## test
        #css  = "position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
        #css += "padding: 20px; background-color:rgba(220, 220, 220, 0.85);"
        #css += "color: #fff; font-size: 50px; font-familt: 'Century Gothic';"
        #$("body").append '<div id="ss-loading" style="' + css + '">Loading ... </div>'
      error: (req, status, error)->
        $("body").html SS.head + SS.page
    }
  
  @piece: (id, url) ->
    url = url.replace(/\.json$/, ".kana.json") if location.href.match(/\.kana\.html$/)
    $.ajax {
      type: "GET", url: url, dataType: "json"
      #cache: false
      success: (data)->
        $(id).replaceWith data
    }
  
  @kana: (id) ->
    url = location.href
    if url.match(/\.kana\.html$/)
      url = url.replace(/\.kana\.html$/, ".html")
      $(id).html('<a class="off" href="' + url + '">ふりがなをはずす</a>')
    else
      url = url.replace(/\/$/, "/index.html").replace(/\.html$/, ".kana.html")
      $(id).html('<a class="on" href="' + url + '">ふりがなをつける</a>')
      #$(id).html('<a class="on" href="' + url + '" onclick="return SS.kana2(this)">ふりがなをつける</a>')
  
  @kana2: (url) ->
    $.ajax {
      type: "GET", url: url, dataType: "html"
      #cache: false
      success: (data)->
        $("body").html data.replace(/[\s\S]*<body.*?>([\s\S]*)<\/body>[\s\S]*/, "$1")
    }
    return false
