$(document).on 'ready turbolinks:load', ->
  $artist_search = $('#artist-search')
  $all_artists = $('#search-result-list table tbody').children('tr')
  if $('body.tutorials').length
    $(".artist-selector").on('click','.artist-item', ->
      $artist_search.val("")
      $class = $(this).attr('class').split(" ")[1]
      $target = $(".#{$class}")
      $target.find('i.fa-star').addClass('hidden')

      $target.find('.favorite').addClass('star').addClass('active')
      #$(this).find('i.fa-star').addClass('hidden')
      #$(this).find('.favorite').addClass('star').addClass('active')
    )
