class @SortAppearanceArtist
  @run: ->
    if $("header nav .signed-in, body.tutorials").length
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

$(document).on 'turbolinks:load', ->
  SortAppearanceArtist.run()
