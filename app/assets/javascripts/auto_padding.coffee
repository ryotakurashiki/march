$(document).on 'turbolinks:load', ->
  padding = $("header").height()
  $("#main").css('padding-top', padding)