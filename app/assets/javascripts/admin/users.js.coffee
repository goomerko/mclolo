# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#select_all_nodes').click( ->
    $("[name='user[node_ids][]']").attr('checked', 'checked')
    return false
    )
