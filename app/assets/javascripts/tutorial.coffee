$ ->
  $(".artist-selector").on('click','.artist-item', ->
    $class = $(this).attr('class').split(" ")[1]
    $target = $(".#{$class}")
    $target.find('i.fa-star').addClass('hidden')
    $target.find('.favorite').addClass('star').addClass('active')

    #$(this).find('i.fa-star').addClass('hidden')
    #$(this).find('.favorite').addClass('star').addClass('active')
  )

  $all_artists = $('#search-result-list table tbody').children('tr')
  $search_result_list = $('#search-result-list')
  $search_result_table = $('#search-result-list table')
  $search_result_tbody = $('#search-result-list table tbody')
  $artist_search = $('#artist-search')

  $artist_search.bind('keydown keyup',(e) ->
    $search_result_table.removeClass('hidden')
    $search_result_list.css('height', '112px')

    input_text = e.currentTarget.value
    reg = new RegExp(input_text, "i")

    $searched_artists = $.grep( $all_artists, (artist) ->
      return artist.innerText.match(reg)
    )

    $search_result_tbody.empty().append($searched_artists)
  )

