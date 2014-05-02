(function(){
  
  $('#select_group_id').change(function(){
    var group_id = $("#select_group_id").val();
    $.get("form-group-user.js?select_group_id=" + group_id);
  });

});
