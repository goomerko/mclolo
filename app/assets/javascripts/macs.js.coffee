# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $.mask.definitions['h'] = "[A-Fa-f0-9]";
  $('#mac_mac').mask('hh:hh:hh:hh:hh:hh')
  $('#mac_node').focus()
  $('#search_term').focus()
