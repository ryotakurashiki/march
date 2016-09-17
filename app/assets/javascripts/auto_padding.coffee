$(document).on 'ready turbolinks:load', ->
  padding = $("header").height()
  $("#main").css('padding-top', padding)