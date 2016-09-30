$(document).on 'turbolinks:load', ->
  $search_result_list = $('#search-result-list')
  $search_result_table = $('#search-result-list table')
  $artist_search = $('#artist-search')

  $artist_search.bind('keydown keyup',(e) ->
    $search_result_table.removeClass('hidden')
    $search_result_list.css('height', '112px')
    input_text = e.currentTarget.value

    $.ajax({
      #url: location.pathname + '/filter',
      url: "#{location.protocol}//#{location.host}/search/filter",
      type: 'POST',
      data: {
        input_text: input_text
      },
      dataType: 'script'
    })
  )

###
  $artist_search.bind('keydown keyup',(e) ->
    $search_result_table.removeClass('hidden')
    $search_result_list.css('height', '112px')

    input_text = e.currentTarget.value
    #reg = new RegExp(input_text, "i")

    $searched_artists = $.grep( $all_artists, (artist) ->
      #return artist.innerText.match(reg)
      ~artist.innerText.indexOf(input_text)
    )
    $search_result_tbody.empty().append($searched_artists)
  )
###
