$(document).on 'ready turbolinks:load', ->
  $artist_search = $('#artist-search')
  if $('body.user.statics.search').length
    $(".artist-list").on('click','.artist-item .favorite', ->
      $artist_search.val("")
    )
