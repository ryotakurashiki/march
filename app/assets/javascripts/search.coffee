$ ->
  $artist_search = $('#artist-search')
  if $('body.user.statics.search').length
    $(".artist-list").on('click','.artist-item .favorite', ->
      $artist_search.val("")
      $class = $(this).parent().attr('class').split(" ")[1]
      $target = $(".#{$class}")
      $target.find('i.fa-star').addClass('hidden')
      $target.find('.favorite').addClass('star').addClass('active')
      #$(this).find('i.fa-star').addClass('hidden')
      #$(this).find('.favorite').addClass('star').addClass('active')
    )
