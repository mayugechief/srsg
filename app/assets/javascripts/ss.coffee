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
