$(document).on 'turbolinks:load', ->
  if $('body.user.concerts').length
    $create_artist_input = $('#artist_name')
    $create_artist_submit = $('#create_artist_submit')

    $('#show-artist-search-modal').on('click', ->
      $("#modal-wrapper").fadeIn()
    )
    $(".artist-list").on('click','.artist-item', ->
      artist_id = $(this).attr("id").match(/[0-9].*/)[0]
      artist_name = $(this).find("td a span").text()

      #新しいかの判定
      aids = $(".appearance_artists div").map( ->
        $(this).attr("id").match(/[0-9].*/)[0]
      ).get()
      if (aids.indexOf(artist_id) == -1)
        $("#add-artist-success-msg").fadeIn()
        $('#artist-search').val("")
        setTimeout( ->
          $("#add-artist-success-msg").fadeOut()
        , 1000)
        appearance_artist_item = create_appearance_artist_item(artist_id, artist_name)
        $('.appearance_artists').append(appearance_artist_item)
    )

    $('.close-modal').on('click', -> $("#modal-wrapper").fadeOut())
    $create_artist_input.bind('keydown keyup',(e) ->
      if $create_artist_input.val() == ""
        $create_artist_submit.prop("disabled", true)
      else
        $create_artist_submit.prop("disabled", false)
    )

    $('.appearance_artists').on('click', 'div .fa-times',  ->
      $(this).parent('div').remove()
    )

    create_appearance_artist_item = (artist_id, artist_name) ->
      num = $(".appearance_artists input").length
      "<div id='aid-" + artist_id + "'><i class='fa fa-times'></i><input readonly='readonly' value='" + artist_id + "' type='hidden' name='appearance_artist[artist_id][" + num + "]'><input disabled='disabled' value='" + artist_name + "'></div>"
