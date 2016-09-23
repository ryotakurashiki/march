$ ->
  if $('body.users.joined').length
    console.log("hoge")
    $("#params_year").change( ->
      location.href= location.pathname + "?year=" + this.value
    )