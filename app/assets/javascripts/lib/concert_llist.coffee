$ ->
  $(".concert-item").on('click','.artist-item', ->
    $artist_search.val("")
    $class = $(this).attr('class').split(" ")[1]
    $target = $(".#{$class}")
    $target.find('i.fa-star').addClass('hidden')

    $target.find('.favorite').addClass('star').addClass('active')
    #$(this).find('i.fa-star').addClass('hidden')
    #$(this).find('.favorite').addClass('star').addClass('active')
  )
