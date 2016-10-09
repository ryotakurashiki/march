$(document).on 'turbolinks:load', ->
  if $('body.users.joined').length
    $("#params_year").change( ->
      location.href= location.pathname + "?year=" + this.value
    )
