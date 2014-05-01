//= require jquery
//= require jquery_ujs
//= require jquery.cookie
#//= #require jquery.turbolinks
#//= #require turbolinks

class @SS
  @head = ""
  @page = ""
  @href = ""
  @siteName = null
  @pageName = null
  @viewPort = 'width=device-width,initial-scale=1.0,user-scalable=yes,minimum-scale=1.0,maximum-scale=2.0'
  @loading  = '<img style="vertical-align:middle" src="/images/loading.gif" alt="loading.." />'
  
  @load: ->
    if layout = $("#page").attr("data-layout")
      SS.siteName = $("#ss-site-name").html()
      SS.pageName = $("#ss-page-name").html()
      SS.layout(layout)
    
  @layout: (url) ->
    head = $("head")
    body = $("body")
    
    SS.head = head.html()
    SS.page = $("#page").html()
    
    body.html ""
    url = url.replace(/\.json$/, ".kana.json") if SS.kana()
    
    $.ajax {
      type: "GET", url: url, dataType: "json", cache: false
      success: (data) ->
        body.hide()
        body.append data.body.replace("</ yield />", SS.page)
        
        $("#ss-site-name").html SS.siteName
        $("#ss-page-name").html SS.pageName
        SS.renderKana()
        SS.renderMobile()
        
        if data.href != SS.href
          if SS.href
            head.children("link").remove()
            head.children("script").remove()
          head.append data.head.replace(/\$now/g, $.now())
          if !head.children("meta[name=viewport]").length
            head.append '<meta name="viewport" content="' + SS.viewPort + '" />'
        SS.href = data.href
        
        body.fadeIn(70)
      error: (req, status, error) ->
        body.html SS.page
      complete: ->
        $(".ss-part").each ->
          SS.renderPart $(this)
    }
  
  @renderPart: (elm) ->
    url = elm.data("href")
    url = url.replace(/\.json/, ".kana.json") if SS.kana()
    
    elm.append " " + SS.loading
    $.ajax
      type: "GET", url: url, dataType: "json" #, cache: false
      data: "ref=" + location.pathname
      success: (data) ->
        $(elm).replaceWith data
      error: ->
        $(elm).find("img").remove()
  
  ## kana
  
  @kana: (flag = null) ->
    body = $("body")
    return body.data("kana", flag) if flag != null
    return body.data("kana") if body.data("kana") != undefined
    return location.pathname.match(/\.kana\.(html|json)$/) != null
    
  @renderKana: ->
    url  = location.pathname
    bind = 'onclick="return SS.loadKana($(this))"'
    if SS.kana()
      url = url.replace(/\.kana\.html$/, ".html")
      $("#ss-kana").html '<a class="off" href="' + url + '" ' + bind + '>ふりがなをはずす</a>'
    else
      url = url.replace(/\/$/, "/index.html").replace(/(\.kana)?\.html$/, ".kana.html")
      $("#ss-kana").html '<a class="on" href="' + url + '" ' + bind + '>ふりがなをつける</a>'
  
  @loadKana: (elm) ->
    $.ajax
      type: "GET", url: elm.attr("href"), dataType: "html" #, cache: false
      success: (data) ->
        SS.kana elm.hasClass("on")
        $("body").html data.replace(/[\s\S]*<body.*?>([\s\S]*)<\/body>[\s\S]*/, "$1")
    return false
  
  ## mobile view
  
  @renderMobile: ->
    if navigator.userAgent.match(/(Android|iPad|iPhone)/)
      if $.cookie("switchView") == "pc"
        head = $("head")
        head.children("meta[name=viewport]").remove
        head.append '<meta name="viewport" content="width=1024" />'
        vr = $("#ss-mb")
        vr.html('<a href="#" onclick="return SS.renderMobile_mb()">' + vr.text() + '</a>').show()
      else
        vr = $("#ss-pc")
        vr.html('<a href="#" onclick="return SS.renderMobile_pc()">' + vr.text() + '</a>').show()
      
  @renderMobile_pc: ->
    $.cookie("switchView", "pc", { expires: 7, path: '/' })
    location.reload()
    return false
    
  @renderMobile_mb: ->
    $.removeCookie("switchView", { expires: 7, path: '/' })
    location.reload()
    return false
