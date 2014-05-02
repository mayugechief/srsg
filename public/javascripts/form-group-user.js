jQuery(function(){
  $('#jusho_todofuken_id').change(function(){
  var todofuken_id = $("#jusho_todofuken_id").val();
  $.get("todoufuken_select.js?todofuken_id=" + todofuken_id);
});