$(document).on 'turbolinks:load', ->
  $("#prefecture_prefecture_id").change( ->
    console.log(this.value)
    $.ajax({
      url: location.pathname + "/filter",
      method: "post",
      data: {
        prefecture_id: this.value
      },
      dataType: 'script',
      success: ->
        stop_infinitescroll()
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
      dataType: 'script',
      success: ->
        stop_infinitescroll()
    })
  )

  stop_infinitescroll = ->
    $("#concerts .concert-list").infinitescroll
      navSelector: "dummy"
      nextSelector: "dummy"
      itemSelector: "dummy"
