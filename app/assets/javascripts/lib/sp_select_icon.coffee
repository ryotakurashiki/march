$(document).on 'turbolinks:load', ->
  agent = navigator.userAgent
  if(agent.search(/iPhone|iPad|Android/) == -1)
    $('span.select').removeClass("sp")