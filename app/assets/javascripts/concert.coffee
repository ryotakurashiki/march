$(document).on 'turbolinks:load', ->
  if $('body.concerts').length
    $("#artist_id").change( ->
      if this.value
        location.href = "#{location.protocol}//#{location.host}/artists/" + this.value + "/concerts"
      else
        location.href = "#{location.protocol}//#{location.host}/concerts"
    )
