$ ->
  $("#related_artist-list, #artist-list").on('click','.artist-item', ->
    $(this).find('i.fa-star').addClass('hidden')
    $(this).find('.favorite').addClass('star').addClass('active')
  )
