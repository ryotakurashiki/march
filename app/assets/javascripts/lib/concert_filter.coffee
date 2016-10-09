$(document).on 'turbolinks:load', ->
  $("#prefecture_prefecture_id, #date_year").change( ->
    prefecture_id = $("#prefecture_prefecture_id")[0].value
    year = $("#date_year")[0].value
    display_loading_image()

    if $('body.tutorials').length
      artist_id = $("#artist_id")[0].value
      url = "#{location.protocol}//#{location.host}/artists/#{artist_id}/concerts/filter"
    else
      url = location.pathname + "/filter"

    $.ajax({
      url: url,
      method: "post",
      data: {
        prefecture_id: prefecture_id,
        year: year
        artist_id: artist_id
      },
      dataType: 'script',
      success: ->
        if prefecture_id || year
          stop_infinitescroll()
        else
          restart_infinitescroll()
        SortAppearanceArtist.run()
    })
  )

  stop_infinitescroll = ->
    $("#concerts .concert-list").infinitescroll('unbind')

  restart_infinitescroll = ->
    #$("#concerts .concert-list").infinitescroll('bind')
    $("#concerts .concert-list").infinitescroll('update', state: {currPage: 1})

  display_loading_image = ->
    $("#concerts .concert-list").empty()
    loading_img = "<img alt='Loading...' src='" + image_path('loading.gif') + "'/>"
    $("#concerts .concert-list").append("<div id='loading-concerts'>" + loading_img + "</div>")
