$(document).on 'turbolinks:load', ->
  $("#prefecture_prefecture_id, #date_year").change( ->
    console.log(this.value)
    prefecture_id = $("#prefecture_prefecture_id")[0].value
    year = $("#date_year")[0].value
    console.log(prefecture_id)
    console.log(year)
    $.ajax({
      url: location.pathname + "/filter",
      method: "post",
      data: {
        prefecture_id: prefecture_id,
        year: year
      },
      dataType: 'script',
      success: ->
        if prefecture_id || year
          stop_infinitescroll()
        else
          restart_infinitescroll()
    })
  )

  stop_infinitescroll = ->
    $("#concerts .concert-list").infinitescroll('unbind')

  restart_infinitescroll = ->
    $("#concerts .concert-list").infinitescroll('bind')
    $("#concerts .concert-list").infinitescroll('update', state: {currPage: 1})
