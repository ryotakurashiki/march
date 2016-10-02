$(document).on 'turbolinks:load', ->
  if $("header nav .signed-in").length
    $(".appearance-artists").each( (index, ele) ->
      console.log("hoge")
      cid = $(ele).attr("cid")
      console.log(cid)

      $.ajax({
        url: "#{location.protocol}//#{location.host}/appearance_artists/sort",
        type: 'POST',
        data: {
          concert_id: cid
        },
        dataType: 'script'
      })
    )

