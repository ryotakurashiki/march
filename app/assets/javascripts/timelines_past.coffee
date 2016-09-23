$(document).on 'ready turbolinks:load', ->
  if $('body.users.joined').length

    agent = navigator.userAgent
    if(agent.search(/iPhone|iPad|Android/) == -1)
      console.log("hoge")
      $('span.select').removeClass("sp")

    $("#params_year").change( ->
      location.href= location.pathname + "?year=" + this.value
    )