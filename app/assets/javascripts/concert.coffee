$(document).on 'turbolinks:load', ->
  if $('body.concerts').length
    $("#artist_id").change( ->
      location.href= location.pathname + "/" + this.value
      location.href = "#{location.protocol}//#{location.host}/artists/" + this.value + "/concerts"
    )
