$(document).on 'turbolinks:load', ->
  if $('body.user.statics.search').length
    $artist_search = $('#artist-search')
    $(".artist-list").on('click','.artist-item .favorite', ->
      $artist_search.val("")
    )
