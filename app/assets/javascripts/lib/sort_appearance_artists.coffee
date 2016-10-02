$(document).on 'turbolinks:load', ->
  if $("header nav .signed-in").length
    $(".appearance-artists").each( (index, ele) ->
      cid = $(ele).attr("cid")
      $.ajax({
        url: "#{location.protocol}//#{location.host}/appearance_artists/sort",
        type: 'POST',
        data: {
          concert_id: cid
        },
        dataType: 'script'
      })
    )

