//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks

$ ->
  $("#crumbs a").each ->
    crumb = $(this)
    $("#navi a").each ->
      menu = $(this)
      menu.addClass("current") if crumb.attr("href") == menu.attr("href")
  
  SS_ListUI.render("table.index")
  SS_Editor.tabs(".plugin-tab")

class @SS_ListUI
  @render: (list)->
    $("table.index tbody tr").each ->
      tr    = $(this)
      tbody = tr.parent()
      tr.find("input[type=checkbox]").each ->
        tr.toggleClass("checked", $(this).prop("checked"))
      tr.find("input[type=checkbox]").change ->
        tr.toggleClass("checked", $(this).prop("checked"))
      tr.mouseup (e) ->
        if !$(e.target).is('a') && !$(e.target).is("input")
          tbody.find("input[type=checkbox]").attr("checked", false)
          tbody.find("tr").removeClass("checked")
          tr.find(".row-menu").css("left", e.pageX + 5).css("top", e.pageY).show()
          tr.find("input[type=checkbox]").trigger("click")
      tr.mouseleave ->
        tr.find(".row-menu").hide()

class @SS_Editor
  @tabs: (tabs)->
    $(tabs).click (ev) ->
      $(tabs).each ->
        $($(this).attr("data-id")).hide(0)
        $(this).removeClass("current");
      $($(this).attr("data-id")).fadeIn(150)
      $(this).addClass("current");
      ev.preventDefault();

class @SS_Form
  @move_confirm: ()->
    $("input[type=text],textarea,select").change ->
      $(window).on "beforeunload", ->
        return "このページから移動しますか？"
    $("input[type=submit]").click ->
      $(window).off "beforeunload"

class @SS_Debug
  @test: ()->
    $("#log").val("")
    $("#err").val("")
    $("#queue").val("0")
    SS_Debug.test_url location.href
  
  @test_url: (url)->
    return if url.match(/^#/)
    return if url.match(/\/logout$/)
    if url.match(/^https?:/)
      return unless url.match(new RegExp(location.host))
      url = url.replace(/^https?:\/\/.*?\//, "/")
    else if url.match(/^[^\/]/)
      return
    
    view = $("#log")
    path = url.replace(/\d+/g, "123")
    return true if view.val().match(new RegExp("^" + path + "$", "m"))
    view.val view.val() + path + "\n"
    view.scrollTop view[0].scrollHeight - view.height()
    
    queue = $("#queue")
    queue.val parseInt(queue.val()) + 1
    
    $.ajax {
      type: "GET", url: url, dataType: "html", cache: false
      success: (data, status, xhr)->
        queue.val parseInt(queue.val()) - 1
        $(data).find("a").each ->
          SS_Debug.test_url $(this).attr("href")
      error: (xhr, status, error)->
        queue.val parseInt(queue.val()) - 1
        view = $("#err")
        view.val view.val() + " [" + xhr.status + "] " + url + "\n"
        view.scrollTop view[0].scrollHeight - view.height()
    }
