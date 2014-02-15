//= require jquery
//= require jquery_ujs
//= require jquery.cookie
#//= #require jquery.turbolinks
#//= #require turbolinks

class @SS
  @head = ""
  @page = ""
  @href = ""
  @kanaFlag = '<div id="kana-view" style="margin:0;padding:0;display:inline"></div>'
  @siteName = null
  @pageName = null
  @viewPort = 'width=device-width,initial-scale=1.0,user-scalable=yes,minimum-scale=1.0,maximum-scale=2.0'
  
  @load: ->
    if layout = $("#page").attr("data-layout")
      SS.siteName = $("#ss-site-name").html()
      SS.pageName = $("#ss-page-name").html()
      SS.layout(layout)
    
  @layout: (url) ->
    SS.head = $("head").html()
    SS.page = $("#page").html()
    isKana  = SS.isKana()
    
    $("body").html ""
    
    url = url.replace(/\.json$/, ".kana.json") if isKana
    $.ajax {
      type: "GET", url: url, dataType: "json", cache: false
      success: (data) ->
        $("body").hide()
        $("body").append SS.kanaFlag if isKana
        $("body").append data.body.replace("</ yield />", SS.page)
        $("#ss-site-name").html SS.siteName
        $("#ss-page-name").html SS.pageName
        
        if data.href != SS.href
          $("head link").add("head script").remove() if SS.href
          $("head").append data.head.replace(/\$now/g, $.now())

        SS.href = data.href
        
        $("body").fadeIn(100)
      error: (req, status, error) ->
        $("body").html SS.page
    }
  
  @piece: (id, url) ->
    url = url.replace(/\.json$/, ".kana.json") if SS.isKana()
    $.ajax {
      type: "GET", url: url, dataType: "json" #, cache: false
      success: (data) ->
        $(id).replaceWith data
    }
  
  @isKana: ->
    $("#kana-view").length || location.pathname.match(/\.kana\.(html|json)$/)
    
  @kana: (id) ->
    url = location.pathname
    if SS.isKana() || url.match(/\.kana\.html$/)
      url = url.replace(/\.kana\.html$/, ".html")
      $(id).html('<a class="off" href="' + url + '">ふりがなをはずす</a>')
    else
      url = url.replace(/\/$/, "/index.html").replace(/\.html$/, ".kana.html")
      evh = 'onclick="return SS.renderKana(this)"'
      $(id).html('<a class="on" href="' + url + '" ' + evh + '>ふりがなをつける</a>')
  
  @renderKana: (url) ->
    $.ajax {
      type: "GET", url: url, dataType: "html" #, cache: false
      success: (data) ->
        $("body").html data.replace(/[\s\S]*<body.*?>([\s\S]*)<\/body>[\s\S]*/, "$1") + SS.kanaFlag
    }
    return false
    
  @switchView: ->
    if navigator.userAgent.match(/(Android|iPad|iPhone)/)
      if $.cookie("switchView") == "pc"
        $("head meta[name=viewport]").remove
        $("head").append '<meta name="viewport" content="width=1024" />'
        sp = $("#sp-view")
        sp.html('<a href="#" onclick="SS.switchSpView()">' + sp.html() + '</a>').show()
      else
        if !$("head meta[name=viewport]").length
          $("head").append '<meta name="viewport" content="' + SS.viewPort + '" />'
        pc = $("#pc-view")
        pc.html('<a href="#" onclick="SS.switchPcView()">' + pc.html() + '</a>').show()
      
  @switchPcView: ->
    $.cookie("switchView", "pc", { expires: 7, path: '/' })
    location.reload()
    
  @switchSpView: ->
    $.removeCookie("switchView", { expires: 7, path: '/' })
    location.reload()
