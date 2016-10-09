$(document).on 'turbolinks:load', ->
  if $('body.user.concerts').length
    $create_artist_input = $('#artist_name')
    $create_artist_submit = $('#create_artist_submit')

    # モーダルの表示・非表示
    $('#show-artist-search-modal').on('click', ->
      $("#modal-wrapper").fadeIn()
    )
    # モーダルを閉じる
    $('.close-modal').on('click', ->
      $("#modal-wrapper").fadeOut()
    )

    # 登録した出演アーティストの解除
    $('.appearance_artists').on('click', 'div .fa-times',  ->
      $(this).parent('div').remove()
      if $('.appearance_artists div').length == 0
        $('#create-concert').prop("disabled", true)
    )

    # 出演アーティストの追加
    $(".artist-list").on('click','.artist-item', ->
      artist_id = $(this).attr("id").match(/[0-9].*/)[0]
      artist_name = $(this).find("td a span").text()

      if $('body.new').length
        #新しいかの判定
        aids = $(".appearance_artists div").map( ->
          $(this).attr("id").match(/[0-9].*/)[0]
        ).get()
        if (aids.indexOf(artist_id) == -1)
          aids.push(artist_id)
          check_duplicate_concert(aids)
          $("#add-artist-success-msg").fadeIn()
          $('#artist-search').val("")
          setTimeout( ->
            $("#add-artist-success-msg").fadeOut()
          , 1000)
          appearance_artist_item = create_appearance_artist_item(artist_id, artist_name)
          $('.appearance_artists').append(appearance_artist_item)
          $('#create-concert').prop("disabled", false)
      else if $('body.edit').length
        create_appearance_artist(artist_id)
    )

    # textareaが空だったらアーティストの新規作成submitできない
    $create_artist_input.bind('keydown keyup',(e) ->
      if $create_artist_input.val() == ""
        $create_artist_submit.prop("disabled", true)
      else
        $create_artist_submit.prop("disabled", false)
    )

    create_appearance_artist_item = (artist_id, artist_name) ->
      num = $(".appearance_artists input").length
      "<div id='aid-" + artist_id + "'><i class='fa fa-times'></i><input readonly='readonly' value='" + artist_id + "' type='hidden' name='appearance_artist[artist_id][" + num + "]'><input disabled='disabled' value='" + artist_name + "'></div>"

    check_duplicate_concert = (aids) ->
      date_text = $('#concert_date').val()
      prefecture_id = $('#concert_prefecture_id').val()
      $.ajax({
        url: "#{location.protocol}//#{location.host}/concerts/check_duplicate",
        type: 'POST',
        data: {
          date_text: date_text,
          prefecture_id: prefecture_id,
          aids: aids
        },
        dataType: 'script'
      })

    create_appearance_artist = (artist_id) ->
      concert_id = $('.concert-item').attr("cid")
      $.ajax({
        url: "#{location.protocol}//#{location.host}/concerts/add_appearance_artist",
        type: 'POST',
        data: {
          artist_id: artist_id,
          concert_id: concert_id
        },
        dataType: 'script'
      })

    show_success_msg = ->
      $("#add-artist-success-msg").fadeIn()
      $('#artist-search').val("")
      setTimeout( ->
        $("#add-artist-success-msg").fadeOut()
      , 1000)
