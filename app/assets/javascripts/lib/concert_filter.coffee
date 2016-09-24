$(document).on 'turbolinks:load', ->
  $("#prefecture_prefecture_id").change( ->
    console.log(this.value)
    $.ajax({
      url: location.pathname + "/filter",
      method: "post",
      data: {
        prefecture_id: this.value
      },
      dataType: 'script'
    })
  )

  $("#date_year").change( ->
    console.log(this.value)
    $.ajax({
      url: location.pathname + "/filter",
      method: "post",
      data: {
        year: this.value
      },
      dataType: 'script'
    })
  )