$(document).on 'turbolinks:load', ->
  if $('body.tutorials').length
    $("#related_artist-list").slideUp(0)
    $artist_search = $('#artist-search')
    $all_artists = $('#search-result-list table tbody').children('tr')
    $(".artist-selector").on('click','.artist-item', ->
      $artist_search.val("")
      $class = $(this).attr('class').split(" ")[1]
      $target = $(".#{$class}")
      $target.find('i.fa-star').addClass('hidden')

      $target.find('.favorite').addClass('star').addClass('active')
      #$(this).find('i.fa-star').addClass('hidden')
      #$(this).find('.favorite').addClass('star').addClass('active')
    )

    $("#artist_id").change( ->
      location.href= location.pathname + "/" + this.value
      location.href = "#{location.protocol}//#{location.host}/tutorial/select_concert/" + this.value
    )
