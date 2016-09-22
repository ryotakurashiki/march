$ ->
  $("#prefecture_prefecture_id").change( ->
    console.log(this.value)
    $.ajax({
      url: location.pathname + "/filter",
      method: "post",
      data: {
        prefecture_id: this.value
      },
      dataType: 'json'
    })
  )