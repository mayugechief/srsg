## select group form

$ ->
  $("#select_group_id").change ->
    group_id = $("#select_group_id").val()
    $.get "select_group_users.js?select_group_id=" + group_id, (data) ->
      $("#item_user_id").html data
      return
