$(document).on 'ready turbolinks:load', ->
  $all_artists = $('#search-result-list table tbody').children('tr')
  $search_result_list = $('#search-result-list')
  $search_result_table = $('#search-result-list table')
  $search_result_tbody = $('#search-result-list table tbody')
  $artist_search = $('#artist-search')

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


#$.ajax({
#    url: location.pathname + "/social_accounts",
#    dataType: 'json',
#    success: (json) ->
#      return false  if json.length == 0
#      if twitter = json.twitter
#        $("#twitter_followers_count")
#         .html(numberFormat(twitter.followers_count))
#    if facebook = json.facebook
#     $("#facebook_followers_count")
#      .html(numberFormat(facebook.followers_count))
#  })