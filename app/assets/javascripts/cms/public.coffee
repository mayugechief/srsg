//= require jquery
//= require jquery_ujs
#//= #require jquery.turbolinks
#//= #require turbolinks

class @SS
  @head = ""
  @page = ""
  @href = ""
  @kana_flag = '<div id="kana-view" style="margin:0;padding:0;display:inline"></div>'
  @site_name = null
  @page_name = null
  
  @load: ->
    if layout = $("#page").attr("data-layout")
      SS.site_name = $("#ss-site-name").html()
      SS.page_name = $("#ss-page-name").html()
      SS.layout(layout)
    
  @layout: (url) ->
    is_kana = SS.is_kana()
    
    SS.head = $("head").html()
    SS.page = $("#page").html()
    
    $("body").html ""
    
    url = url.replace(/\.json$/, ".kana.json") if is_kana
    $.ajax {
      type: "GET", url: url, dataType: "json", cache: false
      success: (data)->
        $("body").hide()
        $("body").append SS.kana_flag if is_kana
        $("body").append data.body.replace("</ yield />", SS.page)
        $("#ss-site-name").html SS.site_name
        $("#ss-page-name").html SS.page_name
        
        if data.href != SS.href
          $("head link").add("head script").remove() if SS.href
          $("head").append data.head.replace(/(href="[^"]+)/g, '$1?_=' + $.now())
          #$("head").append '<link rel="stylesheet" href="/assets/cms/public.css" />' #TODO:
        SS.href = data.href
        
        $("body").fadeIn(100)
      error: (req, status, error)->
        $("body").html SS.head + SS.page
    }
  
  @piece: (id, url) ->
    url = url.replace(/\.json$/, ".kana.json") if SS.is_kana()
    $.ajax {
      type: "GET", url: url, dataType: "json" #, cache: false
      success: (data)->
        $(id).replaceWith data
    }
  
  @is_kana: ->
    $("#kana-view").length || location.href.match(/\.kana\.(html|json)$/)
    
  @kana: (id) ->
    url = location.href
    if SS.is_kana() || url.match(/\.kana\.html$/)
      url = url.replace(/\.kana\.html$/, ".html")
      $(id).html('<a class="off" href="' + url + '">ふりがなをはずす</a>')
    else
      url = url.replace(/\/$/, "/index.html").replace(/\.html$/, ".kana.html")
      evh = 'onclick="return SS.view_kana(this)"'
      $(id).html('<a class="on" href="' + url + '" ' + evh + '>ふりがなをつける</a>')
  
  @view_kana: (url) ->
    $.ajax {
      type: "GET", url: url, dataType: "html" #, cache: false
      success: (data)->
        $("body").html data.replace(/[\s\S]*<body.*?>([\s\S]*)<\/body>[\s\S]*/, "$1") + SS.kana_flag
    }
    return false
